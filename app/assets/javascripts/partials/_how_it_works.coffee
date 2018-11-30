(($) ->
  $(document).ready ->
    setupClickToScroll()
    setupScrollToTop()
    setupFade()

    # Trigger window.scroll, this will initiate some of the scripts
    $(window).scroll()

  setupScrollToTop = ->
    scrollSpeed = 750
    $('.trigger-scroll-to-top').click (e) ->
      e.preventDefault()
      $('html, body').animate({
        scrollTop: 0
      }, scrollSpeed)

  setupFade = ->
    posts = $('.post-wrapper .post').reverse()
    stemWrapper = $('.stem-wrapper')
    halfScreen = $(window).height() / 2

    $(window).on 'scroll resize', ->
      delay(->
        currScroll = if $(window).scrollTop() > $(document).scrollTop() then $(window).scrollTop() else $(document).scrollTop()
        scrollSplit = currScroll + halfScreen;

        posts.removeClass('active').each ->
          post = $(this)
          postOffset = post.offset().top

          if scrollSplit > postOffset
            # Add active class to fade in
            post.addClass('active')

            # Get post color
            color = if post.data('stem-color') then post.data('stem-color') else null
            allColors = 'color-green color-yellow color-white'

            stemWrapper.removeClass(allColors);

            if color != null
              stemWrapper.addClass('color-' + color);

            return false
      , 20)


  setupClickToScroll = (post) ->
    scrollSpeed = 750

    $('.post-wrapper .post .stem-overlay .icon').click (e) ->
      e.preventDefault()

      icon = $(this)
      post = icon.closest('.post')
      postTopOffset = post.offset().top
      postHeight = post.height()
      halfScreen = $(window).height() / 2
      scrollTo = postTopOffset - halfScreen + (postHeight / 2)

      $('html, body').animate({
        scrollTop: scrollTo
      }, scrollSpeed)
) jQuery



# ==========  Helpers  ==========

# Timeout function
delay = ((callback, ms) ->
  timer = 0;
  return (callback, ms) ->
    clearTimeout (timer);
    timer = setTimeout(callback, ms)
)()

$.fn.reverse = ->
  return this.pushStack(this.get().reverse(), arguments)