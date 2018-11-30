class PermanentSmsFailureJob
  include Sidekiq::Worker

  def perform(args)
    @booking = Booking.find(args['booking_id'])
    notify_slack
  end

  def notify_slack
    notifier = Slack::Notifier.new Rails.application.secrets.slack_booking_channel_webhook
    message = "Permanente fout bij het versturen van een SMS naar #{@booking.telephone_normalized} voor [boeking](#{Rails.application.routes.url_helpers.onsgeheim_booking_url(@booking.token)}) ##{@booking.id}."
    notifier.ping message
  end
end