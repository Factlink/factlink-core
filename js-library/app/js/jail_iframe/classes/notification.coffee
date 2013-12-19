FactlinkJailRoot.showShouldSelectTextNotification = ->
  showNotification
    message: 'To create an annotation, select a statement and click the Factlink button.'
    type_classes: 'fl-message-icon-add'

FactlinkJailRoot.showLoadedNotification = ->
  showNotification
    message: 'Factlink is loaded!'
    type_classes: 'fl-message-icon-time fl-message-success'

in_screen_time = 3000
removal_delay = 1000 # Should be larger than notification_transition_time
content = """
  <div class="fl-message">
    <div class="fl-message-icon"></div><span class="fl-message-content fl-js-message"></span>
  </div>
""".trim()

showNotification = (options) ->
  $el = $(content)

  setMessage = -> $el.find('.fl-js-message').text(options.message)

  render = ->
    $el.addClass(options.type_classes)
    setMessage()
    FactlinkJailRoot.$factlinkCoreContainer.append($el)
    positionElement()

    $el.addClass 'factlink-control-visible'
    setTimeout(remove, in_screen_time)

  positionElement = ->
    $el.css
      top: '65px',
      left: '50%',
      marginLeft: "-#{$el.width()/2}px"

  remove = ->
    $el.removeClass 'factlink-control-visible'
    setTimeout (-> $el.remove()), removal_delay

  render()
