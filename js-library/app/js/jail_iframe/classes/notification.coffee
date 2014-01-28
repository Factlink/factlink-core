FactlinkJailRoot.showShouldSelectTextNotification = ->
  showNotification
    message: 'To create an annotation, select a statement and click the Factlink button.'
    type_classes: 'fl-message-icon-add'

FactlinkJailRoot.showLoadedNotification = ->
  showNotification
    message: 'Factlink is loaded!'
    type_classes: 'fl-message-icon-time fl-message-success'

in_screen_time = 3000

showNotification = (options) ->
  frame = null

  renderFrame = ->
    frame = new FactlinkJailRoot.ControlIframe()
    fillFrame()
    positionFrame()
    doTransition()

  fillFrame = ->
    content = """
      <div class="fl-message #{options.type_classes}">
        <div class="fl-message-icon"></div><span class="fl-message-content">#{options.message}</span>
      </div>
    """.trim()

    frame.setContent($.parseHTML(content)[0])

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
