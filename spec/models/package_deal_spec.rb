# == Schema Information
#
# Table name: package_deals
#
#  id             :integer          not null, primary key
#  restaurant_id  :integer
#  package_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("EUR"), not null
#

require 'rails_helper'

describe PackageDeal do
  let(:price) { 20 }
  let(:package) { FactoryGirl.create(:package, price: price) }
  let(:meeting_point) { FactoryGirl.create(:meeting_point) }
  let(:restaurant) { FactoryGirl.create(:restaurant, meeting_point: meeting_point) }
  let(:package_deal) { FactoryGirl.create(:package_deal, package: package, restaurant: restaurant, price: price) }

  it 'should have a valid factory' do
    expect(package_deal).to be_valid
  end

  context 'validations' do
    it 'price must be a positive integer' do
      package_deal.price = -1
      expect(package_deal).to_not be_valid
    end

    it 'can not assign the same package twice to the same restaurant' do
      package_deal
      duplicate_package_deal = FactoryGirl.build(:package_deal, package: package, restaurant: restaurant, price: price)
      expect(duplicate_package_deal).to_not be_valid
    end
  end

  context 'counter cache' do
    it 'must update number_of_packages on restaurant when creating a new package deal' do
      expect{ package_deal }.to change{ restaurant.number_of_packages }.by(1)
    end

    it 'must update package_deals_count on package when creating a new package deal' do
      expect { package_deal }.to change{ package.package_deals_count }.by(1)
    end
  end
end
