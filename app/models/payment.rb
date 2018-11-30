# == Schema Information
#
# Table name: payments
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  booking_id         :integer
#  mollie_payment_id  :string
#  mollie_payment_url :string
#  token              :string
#  payment_status     :string
#  paid_at            :datetime
#  amount_cents       :integer          default(0), not null
#  amount_currency    :string           default("EUR"), not null
#

class Payment < ActiveRecord::Base
  MOLLIE_PAYMENT_STATUSES = %w(open cancelled pending expired failed paid paidout refunded charged_back).freeze

  require 'Mollie/API/Client'

  belongs_to :booking

  default_scope -> { order(created_at: :asc) }

  validates :amount, :booking, presence: true

  before_create :generate_token
  before_create :default_values
  before_create :mollie_api_create_payment

  after_update -> { touch(:paid_at) }, if: Proc.new { |payment| payment.paid? && !payment.paid_at? }
  after_update :handle_payment_status

  monetize :amount_cents, allow_nil: true
  validate :validate_can_create_payment
  validates :payment_status, inclusion: { in: MOLLIE_PAYMENT_STATUSES }, allow_nil: true

  def paid?
    %w(paid paidout).include? payment_status
  end

  def handle_mollie_webhook_response
    update_attribute(:payment_status, mollie_get_payment.status)
  end

  private

  def mollie_api_create_payment
    payment = mollie.payments.create(
        amount: amount.to_d,
        description: 'Betaling aan SurpriseDinner',
        redirectUrl: Rails.application.routes.url_helpers.booking_payment_url(
            booking_token: booking.token
        )
    )

    self.mollie_payment_id = payment.id
    self.mollie_payment_url = payment.payment_url
  end

  def mollie_get_payment
    mollie.payments.get(mollie_payment_id)
  end

  def mollie
    api = Mollie::API::Client.new
    api.api_key = ENV['MOLLIE_API_KEY']
    api
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Payment.exists?(token: random_token)
    end
  end

  def default_values
    self.payment_status ||= 'open'
  end

  def validate_can_create_payment
    errors.add(:booking, I18n.t('errors')) if
        Payment.exists?(booking_id: booking_id, payment_status: 'paid')
  end

  def handle_payment_status
    case payment_status
      when 'paid' then booking.scheduled_jobs.create!(job_name: 'CompleteBookingJob', args: {booking_id: booking_id})
      when 'charged_back' then booking.scheduled_jobs.create!(job_name: 'ChargeBackBookingJob', args: {booking_id: booking_id})
    end
  end
end
