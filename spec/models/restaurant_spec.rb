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

require 'rails_helper'

describe Restaurant do
  let!(:restaurant) { FactoryGirl.create(:restaurant) }
  let!(:invalid_restaurant_meeting_point) { FactoryGirl.build(:invalid_restaurant_meeting_point) }
  let!(:invalid_restaurant_address) { FactoryGirl.build(:invalid_restaurant_address) }

  it 'has a valid factory' do
    expect(restaurant).to be_valid
  end

  context 'validations' do
    it 'should have an address' do
      expect(invalid_restaurant_address).to_not be_valid
    end

    it 'should have a meeting point' do
      expect(invalid_restaurant_meeting_point).to_not be_valid
    end

    it 'should have a valid IBAN' do
      restaurant.iban = 'invalid'
      expect(restaurant).to_not be_valid
    end

    it 'should have a valid BIC' do
      restaurant.bic = 'invalid'
      expect(restaurant).to_not be_valid
    end
  end

  context 'callbacks' do
    it 'should strip whitespace from IBAN field' do
      stripped_iban = restaurant.iban
      restaurant.update(iban: " #{restaurant.iban} ")
      expect(restaurant.reload.iban).to eq stripped_iban
    end
  end

  context 'scopes' do
    context 'in city' do
      let!(:city) { 'Groningen' }
      let!(:city_address) { FactoryGirl.create(:address, city: city) }
      let!(:other_city_address) { FactoryGirl.create(:address, city: city.reverse ) }
      let!(:restaurant) { FactoryGirl.create(:restaurant, address: city_address) }
      let!(:restaurant_in_different_city) { FactoryGirl.create(:restaurant, address: other_city_address) }

      it '#in_city(city) returns restaurant in city' do
        expect(Restaurant.in_city(city))
            .to include restaurant
      end

      it '#in_city(city) does not return restaurants in different cities' do
        expect(Restaurant.in_city(city))
            .to_not include restaurant_in_different_city
      end
    end

    context 'with package' do
      let!(:restaurant_with_package) { FactoryGirl.create(:restaurant_with_package) }
      let!(:restaurant_with_different_package) { FactoryGirl.create(:restaurant_with_package) }

      it '#with_packge(package) returns restaurants who serve package' do
        expect(Restaurant.with_package(restaurant_with_package.packages.first))
            .to include restaurant_with_package
      end

      it '#with_package(package) does not return restaurants that do not serve that package' do
        expect(Restaurant.with_package(restaurant_with_package.packages.first))
            .to_not include restaurant_with_different_package
      end
    end
  end

  context 'public methods' do
    pending
  end
end
