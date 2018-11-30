# == Schema Information
#
# Table name: bookings
#
#  id                   :integer          not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  telephone            :string
#  email                :string
#  restaurant_id        :integer
#  package_id           :integer
#  persons              :integer
#  telephone_normalized :string
#  notes                :text
#  name                 :string
#  status               :string
#  token                :string           not null
#  notified_at          :datetime
#  at                   :datetime
#  personal_message     :text
#  slug                 :string
#  city_id              :integer
#

class Booking < ActiveRecord::Base
  has_one :code
  has_one :coupon_redemption
  has_one :coupon, through: :coupon_redemption
  has_many :payments
  has_many :scheduled_jobs, as: :schedulable, dependent: :destroy
  belongs_to :restaurant
  belongs_to :package
  belongs_to :city

  delegate :price, :name, to: :package, prefix: true, allow_nil: true

  PHONE_DEFAULT_COUNTRY_CODE = 'NL'.freeze
  COMPLETE_STATUS = 'completed'.freeze
  attr_writer :date, :time
  cattr_accessor :wizard_steps do
    %w(wat_en_wie contactgegevens afronden)
  end

  before_validation :set_at
  before_validation :set_booking_slug, if: ->(booking) { booking.completed? && slug.blank? }
  before_create :generate_token

  after_validation :normalize_phone
  after_save :create_code, if: -> (booking) { booking.completed? && booking.code.nil? }
  after_update :handle_activation_mail
  after_update :reschedule_booking!, if: -> (booking) { booking.completed? && at_changed? }

  scope :uncompleted, -> { where('status != ? or status is null', COMPLETE_STATUS) }
  scope :completed, -> { where(status: COMPLETE_STATUS) }
  scope :processed, -> { completed.where.not(restaurant_id: nil) }
  scope :to_be_processed, -> { completed.where(restaurant_id: nil) }
  scope :on_date, ->(date) { where(at: date.beginning_of_day..date.end_of_day) }
  scope :in_month, ->(date) { where(at: date.beginning_of_month..date.end_of_month) }

  # Validations for first wizard step
  # TODO: better validation for date and time fields
  validates :at, :persons, :package, :city,
            presence: true, if: :completed_or_wat_en_wie_step_done?
  validates :persons, numericality: {
    only_integer: true, greater_than: 0, less_than: 100
  }, if: :completed_or_wat_en_wie_step_done?

  # Validations for second wizard step
  validates :name, :email, :telephone,
            presence: true, if: :completed_or_contactgegevens_step_done?
  validates :email, email: true, if: :completed_or_contactgegevens_step_done?
  validate :phone_number_validation, if: :completed_or_contactgegevens_step_done?
  validates :slug, presence: true, uniqueness: true, if: -> (booking) { booking.completed? }

  def to_param
    token
  end

  def total_price
    price = package.price * persons
    coupon_redemption ? price - coupon_redemption.discount : price
  end

  def complete
    scheduled_jobs.create!(job_name:'CompleteBookingJob', args: {booking_id: id})
  end

  def completed?
    status == COMPLETE_STATUS
  end

  def time
    at.strftime('%H:%M') if at
  end

  def date
    I18n.l(at, format: '%A %-d %B %Y') if at
  end

  def notify_at
    at - 1.hour
  end

  def send_feedback_mail_at
    (at + 1.day).change(hour: 12)
  end

  def paid?
    payments.exists?(payment_status: 'paid') || payments.exists?(payment_status: 'paidout')
  end

  def activated?
    try(:code).try(:activated?)
  end

  wizard_steps.each do |step|
    define_method "completed_or_#{step}_step_done?" do
      completed? ||
        (status && wizard_steps.index(step) <= wizard_steps.index(status))
    end
  end

  def set_received_notification!
    touch(:notified_at) unless notified_at?
  end

  def previous_bookings
    self.class.completed.includes(:restaurant, :package).
        where('email = ? OR telephone = ? OR telephone_normalized = ?', email, telephone, telephone).
        where.not(id: id)
  end

  def set_booking_slug
    self.slug = Bookings::SlugGenerator.new(self).generate
  end

  def profit
    return 0 unless restaurant
    deal_price = restaurant.package_deals.find_by(package: package).price * persons
    total_price - deal_price
  end

  private

  def normalize_phone
    self.telephone_normalized = PhonyRails.normalize_number(self.telephone, default_country_code: PHONE_DEFAULT_COUNTRY_CODE)
  end

  def phone_number_validation
    unless PhonyRails.plausible_number?(self.telephone, default_country_code: PHONE_DEFAULT_COUNTRY_CODE)
      errors.add(:telephone, :invalid)
    end
  end

  def set_at
    date = instance_variable_get('@date')
    time = instance_variable_get('@time')
    return if date.blank? || time.blank?
    self.at = Time.zone.parse("#{date} #{time}").to_datetime
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  def handle_activation_mail
    return unless completed? &&
                  restaurant_id_changed? &&
                  restaurant_id_was.nil?

    BookingMailer.activate_booking(self.reload).deliver_later
  end

  def reschedule_booking!
    ActiveRecord::Base.transaction do
      ScheduledJob.find_or_schedule!(self, 'SendMeetingPointSmsJob', {booking_id: id}, notify_at).reschedule_at(notify_at)
      ScheduledJob.find_or_schedule!(self, 'BookingMailerJob', { booking_id: id, template:'feedback_form' }, send_feedback_mail_at).reschedule_at(send_feedback_mail_at)
    end

    BookingMailer.reschedule_booking(self).deliver_later
  end
end
