class BookingMailerPreview < ActionMailer::Preview
  def payment_confirmed
    booking = FactoryGirl.build(:booking)
    BookingMailer.payment_confirmed(booking)
  end

  def activate_booking
    booking = FactoryGirl.build(:booking)
    booking.code = FactoryGirl.build(:code)
    BookingMailer.activate_booking(booking)
  end

  def feedback_form
    booking = FactoryGirl.build(:booking)
    BookingMailer.feedback_form(booking)
  end

  def reschedule_booking
    booking = FactoryGirl.build(:booking)
    BookingMailer.reschedule_booking(booking)
  end
end
