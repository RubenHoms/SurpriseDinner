# == Schema Information
#
# Table name: coupons
#
#  id                  :integer          not null, primary key
#  code                :string
#  discount_percentage :integer
#  expires_at          :date
#

class Coupon < ActiveRecord::Base
  has_many :coupon_redemptions
  has_many :bookings, through: :coupon_redemptions

  validates :discount_percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  def deactivate
    update(expires_at: Date.today)
  end

  def active?
    expires_at > Date.today
  end
end
