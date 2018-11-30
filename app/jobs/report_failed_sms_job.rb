class ReportFailedSmsJob
  include Sidekiq::Worker

  def perform(args)
    booking = Booking.find(args['booking_id'])
    report = CmSms::Webhook::Response.new(args['report'])
    notifier = Slack::Notifier.new Rails.application.secrets.slack_booking_channel_webhook

    message = "Er is iets mis gegaan met het versturen van een SMS naar #{report.to} voor [boeking](#{Rails.application.routes.url_helpers.onsgeheim_booking_url(booking.token)}) ##{booking.id}. Error #{report.errorcode}, message: #{report.errordescription}"
    notifier.ping message
  end
end