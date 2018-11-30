class SendMeetingPointSmsJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing
  RETRY_TIMEOUT = 5.minutes.freeze
  MAX_RETRY_COUNT = 3.freeze

  def perform(args)
    @retry_count = args['retry_count'] || 0
    @booking = Booking.find(args['booking_id'])

    return if !@booking.paid? || @booking.notified_at? || @booking.code.activated? || permanent_sms_failure?

    response = send_sms
    if response.failure?
      @retry_count += 1
      @booking.scheduled_jobs.create!(job_name: 'SendMeetingPointSmsJob', at: RETRY_TIMEOUT.from_now, args:{ booking_id: @booking.id, retry_count: @retry_count })
      notify_slack(response)
    end
  end

  def permanent_sms_failure?
    max_retry_count_reached? ? @booking.scheduled_jobs.create!(job_name: 'PermanentSmsFailureJob', args: {booking_id: @booking.id}) : false
  end

  def max_retry_count_reached?
    @retry_count >= MAX_RETRY_COUNT
  end

  def send_sms
    sms_notifier = MeetingPointNotifier.send_code(@booking)
    sms_notifier.deliver_now
  end

  def notify_slack(response)
    notifier = Slack::Notifier.new Rails.application.secrets.slack_booking_channel_webhook
    message = "Er is iets mis gegaan met het versturen van een SMS naar #{@booking.telephone_normalized} voor boeking ##{@booking.id}, het word opnieuw geprobeerd in #{RETRY_TIMEOUT.to_i / 60} minuten (poging #{@retry_count}/#{MAX_RETRY_COUNT}). Error #{response.code}, message: #{response.error}"
    notifier.ping message
  end
end