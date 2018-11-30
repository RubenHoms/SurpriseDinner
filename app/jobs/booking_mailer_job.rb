# This class is used as a wrapper around the actual mailer.
# It makes it possible to schedule/reschedule mails to be sent out.
class BookingMailerJob
  include Sidekiq::Worker

  def perform(args)
    booking = Booking.find(args['booking_id'])
    BookingMailer.send(args['template'], booking).deliver_later
  end
end