$ ->
  $('.faq-items li').click ->
    $(this).find('.content').slideToggle(200)
    $(this).find('.glyphicon').toggleClass('glyphicon-chevron-down glyphicon-chevron-up')
