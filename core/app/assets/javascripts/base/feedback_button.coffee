$ ->
  $modal = $('.js-feedback-modal')
  $iframe = $('.js-feedback-modal iframe')
  feedbackWasOpened = false

  openFeedbackFrame = ->
    feedbackWasOpened = true
    $modal.fadeIn('fast')
    $iframe[0].contentWindow.updateHeight()

  $(".js-feedback-modal-link").on 'click', ->
    if !$iframe.attr('src')
      $iframe.attr('src', $iframe.attr('data-src'))
      $iframe.load(openFeedbackFrame)
    else if feedbackWasOpened
      openFeedbackFrame()

  $(".js-feedback-modal-layer").on 'click', ->
    $modal.fadeOut 'fast', ->
      if feedbackWasOpened
        $iframe[0].contentWindow.onCloseFrame()
