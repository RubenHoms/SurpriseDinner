class BookingMailer < ApplicationMailer
  def payment_confirmed(booking)
    merge_vars = [
        { name: 'name', content: booking.name },
        { name: 'email', content: booking.email },
        { name: 'telephone', content: booking.telephone },
        { name: 'persons', content: booking.persons },
        { name: 'date', content: booking.date },
        { name: 'time', content: booking.time },
        { name: 'faq_url', content: Rails.application.routes.url_helpers.faqs_url }
    ]

    body = mandrill_template('Confirmation', merge_vars)
    mail(
      to: booking.email,
      subject: 'Boekingsbevestiging Surprise Dinner',
      body: body,
      content_type: 'text/html'
    )
  end

  def activate_booking(booking)
    @booking = booking
    merge_vars = [
        { name: 'time', content: @booking.time },
        { name: 'expected_at', content: (@booking.at - 15.minutes).strftime('%H:%M') },
        { name: 'expected_date', content: @booking.date },
        { name: 'meeting_point', content: @booking.restaurant.meeting_point.name },
        { name: 'meeting_point_url', content: @booking.restaurant.meeting_point.address.decorate.maps_url },
        { name: 'meeting_point_image_url', content: @booking.restaurant.meeting_point.address.decorate.static_map_image_url},
        { name: 'activation_url', content: Rails.application.routes.url_helpers.activation_url(code: @booking.code.code) },
        { name: 'faq_url', content: Rails.application.routes.url_helpers.faqs_url }
    ]

    body = mandrill_template('Activation', merge_vars)
    mail(
        to: @booking.email,
        subject: 'We hebben een restaurant voor je uitgekozen!',
        body: body,
        content_type: "text/html"
    )
  end

  def feedback_form(booking)
    merge_vars = [
        { name: 'name', content: booking.name },
        { name: 'restaurant', content: booking.restaurant.name },
        { name: 'faq_url', content: Rails.application.routes.url_helpers.faqs_url }
    ]
    body = mandrill_template('Feedback', merge_vars)
    mail(
        to: booking.email,
        subject: "Hoe was je Surprise Dinner bij #{booking.restaurant.name}?",
        body: body,
        content_type: 'text/html'
    )
  end

  def reschedule_booking(booking)
    merge_vars = [
        { name: 'name', content: booking.name },
        { name: 'date', content: booking.date },
        { name: 'time', content: booking.time },
        { name: 'faq_url', content: Rails.application.routes.url_helpers.faqs_url }
    ]

    body = mandrill_template('Reschedule', merge_vars)
    mail(
        to: booking.email,
        subject: 'We hebben je boeking aangepast',
        body: body,
        content_type: 'text/html'
    )
  end

  def request_payment(booking)
    merge_vars = [
        { name: 'name', content: booking.name },
        { name: 'email', content: booking.email },
        { name: 'telephone', content: booking.telephone },
        { name: 'persons', content: booking.persons },
        { name: 'city', content: booking.city.name },
        { name: 'package', content: booking.package.name },
        { name: 'total_price', content: booking.total_price.format },
        { name: 'date', content: booking.date },
        { name: 'time', content: booking.time },
        { name: 'payment_url', content: Rails.application.routes.url_helpers.new_booking_payment_url(booking) },
        { name: 'faq_url', content: Rails.application.routes.url_helpers.faqs_url }
    ]

    body = mandrill_template('Paymentrequest', merge_vars)
    mail(
        to: booking.email,
        subject: 'Boekingsaanvraag voor Surprise Dinner',
        body: body,
        content_type: 'text/html'
    )
  end

  def personal_page(booking)
    merge_vars = [
        { name: 'name', content: booking.name },
        { name: 'personal_page_url', content: Rails.application.routes.url_helpers.booking_slug_url(booking.slug) }
    ]

    body = mandrill_template('Personalpage', merge_vars)
    mail(
        to: booking.email,
        subject: 'Je eerste verrassing!',
        body: body,
        content_type: 'text/html'
    )
  end
end
