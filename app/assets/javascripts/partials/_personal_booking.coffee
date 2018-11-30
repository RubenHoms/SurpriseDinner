$ ->
  booking_date = $('.booking-countdown').data 'booking-date'
  $('.booking-countdown').countdown booking_date, (event) ->
    $(this).find('span.days span').text event.strftime('%-D')
    $(this).find('span.hours span').text event.strftime('%-H')
    $(this).find('span.minutes span').text event.strftime('%-M')
    $(this).find('span.seconds span').text event.strftime('%-S')
