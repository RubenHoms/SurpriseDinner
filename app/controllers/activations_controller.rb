class ActivationsController < ApplicationController
  before_action :assign_variables
  before_action :redirect_when_invalid

  layout 'activation'

  def update
    @code.activate
    @map_image = @restaurant.address.decorate.static_map_image_url
    render :show
  end

  private

  def assign_variables
    @code = Code.includes(booking: [:restaurant]).find_by(code: params[:code])
    @booking = @code.booking
    @restaurant = @booking.restaurant
    @map_image = @restaurant.address.decorate.static_map_image_url if @code.activated?
  end

  def redirect_when_invalid
    redirect_to root_path, alert: t('.alert') unless
      @booking.completed? && @restaurant
  end
end
