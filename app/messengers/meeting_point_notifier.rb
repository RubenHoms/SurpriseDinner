class MeetingPointNotifier < CmSms::Messenger
  default from: Rails.application.secrets.cm_sms_send_from

  def send_code(booking)
    link = Rails.application.routes.url_helpers.activation_url(booking.code.code)
    body = "Hoera, je avontuur begint bijna! Open de link om te zien waar je dineert of wacht tot op het meetingpoint. #{link}"

    content(to: booking.telephone_normalized, body: body, reference: booking.id)
  end
end
