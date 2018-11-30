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

class PackageDeal < ActiveRecord::Base
  belongs_to :package, counter_cache: true
  belongs_to :restaurant, counter_cache: :number_of_packages, inverse_of: :package_deals

  monetize :price_cents, allow_nil: true
  validates :package, uniqueness: { scope: :restaurant, message: 'already added to restaurant.' }
  validates :restaurant, :package, presence: true
  validates :price_cents, numericality: {
      greater_than_or_equal_to: 0
  }

  delegate :price, :price_cents, :name, to: :package, prefix: true, allow_nil: true
end
