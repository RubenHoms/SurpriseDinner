class ChargeBackBookingJob
  include Sidekiq::Worker

  def perform(args)
    @booking = Booking.find(args['booking_id'])
    notify_slack
    # ToDo: Send mail to booking.email that the booking has been canceled
    # and link to how to pay again if they want to continue the booking.
  end

  def notify_slack
    notifier = Slack::Notifier.new Rails.application.secrets.slack_booking_channel_webhook
    message = "Boeking ##{@booking.id} heeft een chargeback gedaan."
    notifier.ping message
  end
end