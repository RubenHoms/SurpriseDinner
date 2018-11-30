class HooksController < ApplicationController
  before_action :check_test_mode, only: :mollie_webhook
  skip_before_filter  :verify_authenticity_token

  def sms_status_report
    begin
      report = CmSms::Webhook::Response.new(params.except(:action, :controller))
      booking = Booking.find(report.reference)

      report.error? ? booking.scheduled_jobs.create!(job_name: 'ReportFailedSmsJob', args:{ booking_id: booking.id, report: report.attributes }) : booking.set_received_notification!

      # The webhook doesn't require a response but let's make sure
      # we don't send anything
      head :ok
    rescue ActiveRecord::RecordNotFound => exception
      Raven.capture_exception(exception) unless report.reference.nil?
      head :ok
    end
  end

  def mollie_webhook
    payment = Payment.find_by_mollie_payment_id params[:id]
    if payment
      payment.handle_mollie_webhook_response
      head :ok
    else
      head :not_found
    end
  end

  private

  def check_test_mode
    head :ok if params[:test_mode]
  end

end