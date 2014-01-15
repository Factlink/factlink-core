$ ->
  $modal = $('.js-feedback-modal')
  $iframe = $('.js-feedback-modal iframe')
  feedbackWasOpened = false

  showFeedbackFrame = ->
    feedbackWasOpened = true
    $modal.fadeIn('fast')
    $iframe[0].contentWindow.updateHeight()
    $iframe.off 'load'

  window.fadeoutFeedbackFrame = -> # also called from frame itself
    $modal.fadeOut 'fast', ->
      if feedbackWasOpened
        $iframe[0].contentWindow.onCloseFrame()

  $(".js-feedback-modal-link").on 'click', ->
    if !$iframe.attr('src')
      $iframe.attr('src', $iframe.attr('data-src'))
      $iframe.on 'load', showFeedbackFrame
    else if feedbackWasOpened
      showFeedbackFrame()

  $(".js-feedback-modal-close").on 'click', ->
    window.fadeoutFeedbackFrame()
