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

require 'rails_helper'

describe Address do
  let!(:address) { create(:address) }
  let!(:invalid_address_telephone) { build(:invalid_address_telephone) }
  let!(:invalid_address_email) { build(:invalid_address_email) }

  it 'has a valid factory' do
    expect(address).to be_valid
  end

  context 'validations' do
    it 'should have a valid email' do
      expect(invalid_address_email).not_to be_valid
    end

    it 'should have a valid phone number' do
      expect(invalid_address_telephone).not_to be_valid
    end

    it 'should be invalid without the required fields' do
      Address::REQUIRED_FIELDS.each do |field|
        expect(address).to be_valid
        initial_value = address.send("#{field}")
        address.send("#{field}=", nil)
        expect(address).to be_invalid
        address.send("#{field}=", initial_value)
      end
    end
  end

  context 'public methods' do
    pending
  end
end
