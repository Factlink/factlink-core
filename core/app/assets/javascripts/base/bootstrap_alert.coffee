$('body').on 'click', '[data-dismiss="alert"]', (e) ->
  $this = $ @
  selector = $this.attr 'data-target'

  e.stopImmediatePropagation()

  if not selector
    selector = $this.attr('href')
    selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') #strip for ie7

  $parent = $ selector

  unless $parent.length
    if $this.hasClass 'alert'
      $parent = $this
    else
      $parent = $this.parent()

  closeAlert($parent)

closeAlert = ($alert) ->
  $alert.trigger(e = $.Event('close'))

  hideAlert = ->
    $alert
      .trigger('closed')
      .fadeOut()

  if $.support.transition and $alert.hasClass('fade')
    $alert.on($.support.transition.end, hideAlert)
  else
    hideAlert()
