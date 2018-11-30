# == Schema Information
#
# Table name: bookings
#
#  id                   :integer          not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  telephone            :string
#  email                :string
#  restaurant_id        :integer
#  package_id           :integer
#  persons              :integer
#  telephone_normalized :string
#  notes                :text
#  name                 :string
#  status               :string
#  token                :string           not null
#  notified_at          :datetime
#  at                   :datetime
#  personal_message     :text
#  slug                 :string
#  city_id              :integer
#

module BookingsHelper
  def restaurant_with_package_deal_price restaurants, package
    restaurants.map do |restaurant|
      package_deal = restaurant.package_deals.where(restaurant: restaurant, package: package).last
      ["#{restaurant.name} (&euro;#{number_with_precision package_deal.price})".html_safe, restaurant.id]
    end
  end
end
