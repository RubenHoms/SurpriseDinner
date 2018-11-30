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

FactoryGirl.define do
  factory :address do
    street FFaker::Address.street_name
    street_number Random.rand(0..100)
    zip_code FFaker::AddressNL.zip_code
    city FFaker::Address.city
    country FFaker::Address.country_code

    factory :full_address do
      telephone FFaker::PhoneNumberNL.phone_number
      email FFaker::Internet.email
    end

    factory :invalid_address_telephone do
      telephone '0612345678901234567890'
    end

    factory :invalid_address_email do
      email 'wrong'
    end
  end
end
