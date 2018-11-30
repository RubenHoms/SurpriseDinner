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

class BookingsController < ApplicationController
  def create
    if params[:city].present?
      city = City.find(params[:city])
      @booking = Booking.create(city: city)
      redirect_to booking_build_path(@booking, Booking.wizard_steps.first)
    else
      flash[:error] = t('.error')
      redirect_to :back
    end
  end

  def show
    @booking = Booking.find_by_slug(params[:booking_slug])
    redirect_to root_path if @booking.nil?
  end
end
