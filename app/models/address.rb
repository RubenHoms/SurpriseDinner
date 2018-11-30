# == Schema Information
#
# Table name: addresses
#
#  id                   :integer          not null, primary key
#  street               :string
#  street_number        :string
#  zip_code             :string
#  city                 :string
#  country              :string
#  latitude             :float
#  longitude            :float
#  telephone            :string
#  telephone_normalized :string
#  email                :string
#  addressable_type     :string
#  addressable_id       :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Address < ActiveRecord::Base

  FIELDS = [:street, :street_number, :zip_code, :city, :country, :telephone, :email]
  REQUIRED_FIELDS = [:street, :street_number, :zip_code, :city, :country]

  belongs_to :adressable, polymorphic: true

  validates :telephone, phony_plausible: { allow_blank: true }
  validates :email, email: true, allow_blank: true
  REQUIRED_FIELDS.each do |field|
    validates field, presence: true
  end
  phony_normalize :telephone, as: :telephone_normalized, default_country_code: 'NL'
  geocoded_by :full_address
  after_validation :geocode

  def full_address
    "#{street} #{street_number}, #{zip_code} #{city}, #{country}" unless [street, zip_code, city, country].include?(nil)
  end

end
