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
#  time                 :datetime
#  persons              :integer
#  telephone_normalized :string
#  name                 :string
#

class Bookings::BuildController < ApplicationController
  include Wicked::Wizard

  before_action :load_booking, :load_packages, :load_coupon_redemption, only: [:show, :update]

  layout 'minimal'

  steps(*Booking.wizard_steps)

  def show
    render_wizard
  end

  def update
    params[:booking][:status] = step_status
    @booking.update_attributes(booking_params)

    render_wizard @booking
  end

  private

  def load_booking
    @booking = Booking.includes(:package).find_by(token: params[:booking_token])
    if @booking.nil?
      redirect_to root_path
    elsif @booking.paid?
      redirect_to booking_payment_path(booking_token: @booking.token)
    end
  end

  def load_packages
    @packages = @booking.city.packages
    redirect_to root_path, alert: t('.no_packages') if @packages.empty?
  end

  def load_coupon_redemption
    @coupon_redemption = @booking.coupon_redemption || @booking.build_coupon_redemption
  end

  def step_status
    step == steps.last ? Booking::COMPLETE_STATUS : step.to_s
  end

  def booking_params
    params.require(:booking).permit(
      :telephone, :email, :time, :date, :persons, :name, :package_id, :status,
      :notes
    )
  end
end
