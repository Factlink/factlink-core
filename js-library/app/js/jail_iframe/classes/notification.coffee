FactlinkJailRoot.showShouldSelectTextNotification = ->
  showNotification
    message: 'To create an annotation, select a statement and click the Factlink button.'
    type_classes: 'fl-message-icon-add'

FactlinkJailRoot.showLoadedNotification = ->
  showNotification
    message: 'Factlink is loaded!'
    type_classes: 'fl-message-icon-time fl-message-success'

in_screen_time = 3000
content = """
  <div class="fl-message">
    <div class="fl-message-icon"></div><span class="fl-message-content fl-js-message"></span>
  </div>
""".trim()

showNotification = (options) ->
  frame = null

  renderFrame = ->
    frame = new FactlinkJailRoot.ControlIframe()
    fillFrame()
    positionFrame()
    doTransition()

  fillFrame = ->
    frame.setContent($.parseHTML(content)[0])
    $el = $(frame.frameBody.firstChild)
    $el.find('.fl-js-message').text(options.message)
    $el.addClass(options.type_classes)
    frame.sizeFrameToFitContent()

  positionFrame = ->
    frame.$el.css
      top: '65px',
      left: '50%',
      position: 'fixed',
      marginLeft: "-#{frame.$el.width()/2}px"

  doTransition = ->
    frame
      .fadeIn()
      .then(-> FactlinkJailRoot.delay(in_screen_time))
      .then(-> frame.fadeOut())
      .then(-> frame.destroy())

  renderFrame()
  return
