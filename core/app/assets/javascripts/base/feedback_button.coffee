$ ->
  $modal = $('.js-feedback-modal')
  $iframe = $('.js-feedback-modal iframe')
  feedbackWasOpened = false

  openFeedbackFrame = ->
    feedbackWasOpened = true
    $modal.fadeIn('fast')
    $iframe[0].contentWindow.updateHeight()
    $iframe.off 'load'

  window.closeFeedbackFrame = -> # also called from frame itself
    $modal.fadeOut 'fast', ->
      if feedbackWasOpened
        $iframe[0].contentWindow.onCloseFrame()

  $(".js-feedback-modal-link").on 'click', ->
    if !$iframe.attr('src')
      $iframe.attr('src', $iframe.attr('data-src'))
      $iframe.on 'load', openFeedbackFrame
    else if feedbackWasOpened
      openFeedbackFrame()

  $(".js-feedback-modal-layer").on 'click', ->
    window.closeFeedbackFrame()
