# == Schema Information
#
# Table name: coupon_redemptions
#
#  id         :integer          not null, primary key
#  coupon_id  :integer
#  booking_id :integer
#

class CouponRedemption < ActiveRecord::Base
  belongs_to :coupon
  belongs_to :booking

  validates_presence_of :coupon, :booking

  def discount
    price = booking.package.price * booking.persons
    discount = (price.to_f / 100) * coupon.discount_percentage
    Money.new(discount * 100)
  end
end
