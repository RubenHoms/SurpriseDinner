# == Schema Information
#
# Table name: payments
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  booking_id         :integer
#  mollie_payment_id  :string
#  mollie_payment_url :string
#  token              :string
#  payment_status     :string
#  paid_at            :datetime
#  amount_cents       :integer          default(0), not null
#  amount_currency    :string           default("EUR"), not null
#

class PaymentsController < ApplicationController
  before_action :load_booking, only: [:new, :show]

  layout 'minimal'

  def new
    @payment = Payment.new(booking: @booking, amount: @booking.total_price)

    if @payment.save
      redirect_to @payment.mollie_payment_url
    else
      flash[:alert] = t('.alert')
      redirect_to :back
    end
  end

  def show
    @payment = Payment.where(booking_id: @booking.id).last

    if @payment
      @payment.handle_mollie_webhook_response
      handle_payment_status(@payment.reload.payment_status)
    else
      redirect_to root_path, alert: t('.alert')
    end
  end

  private

  def load_booking
    @booking = Booking.find_by(token: params[:booking_token])
    redirect_to root_path, alert: t('.alert') unless @booking
  end

  def handle_payment_status(status)
    redirect_to booking_build_url(booking_token: @payment.booking.token, id: :afronden),
                alert: t(".status.#{status}") unless %w(paid paidout).include? status
  end
end
