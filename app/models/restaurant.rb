# == Schema Information
#
# Table name: restaurants
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  name               :string
#  meeting_point_id   :integer
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  number_of_packages :integer          default(0)
#  iban               :string
#  bic                :string
#

class Restaurant < ActiveRecord::Base
  scope :in_city, -> (city) { joins(:address).merge(Address.where('lower(city) = ?', city.downcase)) }
  scope :with_package, -> (package) { joins(:packages).where(packages: { id: package.id }) }

  belongs_to :meeting_point
  has_many :bookings
  has_one :address, as: :addressable, dependent: :destroy
  has_many :package_deals, dependent: :destroy, inverse_of: :restaurant
  has_many :packages, through: :package_deals

  has_attached_file :image,
                    styles: { medium: '370x200' },
                    default_url: '/images/restaurants/placeholder.jpg',
                    processors: [:thumbnail, :paperclip_optimizer]

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :package_deals, allow_destroy: true

  delegate :street, :street_number, :zip_code, :city, :country,
           :telephone, :telephone_normalized, :email, :full_address,
           :latitude, :longitude, to: :address

  before_validation :format_iban
  before_destroy :check_if_has_bookings

  validates :name, :address, :meeting_point, :iban, :bic, presence: true
  validates_with SEPA::IBANValidator
  validates_with SEPA::BICValidator
  validates_attachment :image, content_type: {
    content_type: ['image/jpg', 'image/jpeg', 'image/gif', 'image/png']
  }

  private

  def format_iban
    iban.gsub!(/\s+/, '') if iban.present?
  end

  def check_if_has_bookings
    if bookings.any?
      errors.add(:bookings, 'are registered with this restaurant.')
      return false
    end
    true
  end
end
