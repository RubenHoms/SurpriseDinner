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

FactoryGirl.define do
  factory :package_deal do
    price Random.rand(100).to_f
  end
end
