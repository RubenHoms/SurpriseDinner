class CompleteBookingJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  RANDOM_PUNS = ['Surprise Motherfucker!', 'BAM!', 'Ka-ching!', 'Niet alweer...',
   'Money in the pocket.', 'Rondje van de zaak!',
   'IT\'S RAINING CASH, HALLELUJAH IT\'S RAINING CASH.', 'Wanneer gaan we op vakantie?'].freeze

  def perform(args)
    @booking = Booking.find(args['booking_id'])
    return if @booking.completed?

    ActiveRecord::Base.transaction do
      @booking.scheduled_jobs.create!(job_name: 'SendMeetingPointSmsJob',
                                      args: { booking_id: @booking.id },
                                      at: @booking.notify_at)
      @booking.scheduled_jobs.create!(job_name: 'BookingMailerJob',
                                      args: { booking_id: @booking.id, template: 'feedback_form' },
                                      at: @booking.send_feedback_mail_at)
      @booking.status = Booking::COMPLETE_STATUS
      @booking.save!
    end

    @booking.scheduled_jobs.create!(job_name: 'BookingMailerJob',
                                    args: { booking_id: @booking.id, template: 'personal_page' },
                                    at: 1.hour.from_now)
    BookingMailer.payment_confirmed(@booking).deliver_later
    notify_slack
  end

  def notify_slack
    notifier = Slack::Notifier.new Rails.application.secrets.slack_booking_channel_webhook
    message = "<!channel> #{RANDOM_PUNS.sample} We hebben een [boeking](#{Rails.application.routes.url_helpers.onsgeheim_booking_url(@booking.token)}) ontvangen."
    notifier.ping message
  end
end
