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

FactoryGirl.define do
  factory :settlement do
    booking
    restaurant
    settlement_batch
    total_amount { rand(100)+1 }
  end
end
