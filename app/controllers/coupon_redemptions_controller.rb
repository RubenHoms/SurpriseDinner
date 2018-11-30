# == Schema Information
#
# Table name: coupon_redemptions
#
#  id         :integer          not null, primary key
#  booking_id :integer
#  coupon_id  :integer
#

class CouponRedemptionsController < ApplicationController

  def create
    @booking = Booking.find_by_token params[:booking_token]
    @coupon = Coupon.find_by_code params[:coupon_redemption][:coupon]

    if @booking && @coupon
      # Check if coupon is still valid
      unless @coupon.active?
        return redirect_to booking_build_path(id: 'afronden'), notice: 'De kortingscode is verlopen'
      end

      @booking.create_coupon_redemption(coupon: @coupon)
      redirect_to booking_build_path(id: 'afronden'), notice: 'Kortingscode toegevoegd'
    else
      redirect_to booking_build_path(id: 'afronden'), alert: 'Kortingscode niet gevonden'
    end
  end
end
