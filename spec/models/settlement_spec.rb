# == Schema Information
#
# Table name: settlements
#
#  id                    :integer          not null, primary key
#  booking_id            :integer
#  restaurant_id         :integer
#  settlement_batch_id   :integer
#  total_amount_cents    :integer          default(0), not null
#  total_amount_currency :string           default("EUR"), not null
#  created_at            :datetime
#  updated_at            :datetime
#

require 'rails_helper'

describe Settlement do
  let(:package) { FactoryGirl.create(:package, price: 10) }
  let(:restaurant) { FactoryGirl.create(:restaurant) }
  let(:booking) { FactoryGirl.create(:booking, restaurant: restaurant, package: package) }
  let!(:package_deal) { FactoryGirl.create(:package_deal, package: package, restaurant: restaurant, price: 5) }
  let(:settlement) { FactoryGirl.create(:settlement, restaurant: restaurant, booking: booking) }

  it 'has a valid factory' do
    expect(settlement).to be_valid
  end

  context 'validations' do
    %w(restaurant booking settlement_batch total_amount).each do |field|
      it "should have #{field}" do
        settlement.send("#{field}=", nil)
        expect(settlement).to_not be_valid
      end
    end
  end

  context 'class methods' do
    it 'should return a new settlement based on a booking' do
      new_settlement = described_class.from_booking(booking)
      expect(new_settlement).to have_attributes(
                                    total_amount: package_deal.price * booking.persons,
                                    booking: booking,
                                    restaurant: restaurant
                                )
    end
  end
end
