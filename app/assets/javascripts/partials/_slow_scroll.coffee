$ ->
  $('.slow-scroll').click (e) ->
    e.preventDefault()
    $('html,body').animate { scrollTop: $(@hash).offset().top }, 500
