FACTLINK.Views ||= {}
FACTLINK.Views.Notifications ||= {}

class FACTLINK.Views.Notification
  appendTo: '#fl'
  template: """
    <div class="fl-message">
      <div class="fl-message-icon"></div><span class="fl-message-content fl-js-message"></span>
    </div>
  """

  default_options:
    in_screen_time: 2000
    fade_time: 'slow'
    type_classes: ''

  constructor: (options) ->
    @options = $.extend {}, @default_options, options

    @$el = $(@template)
          .addClass(@options.type_classes)
          .hide()

    @setMessage(@options.message)

  setMessage: (message) ->
    @$el.find('.fl-js-message').text(message)

  render: ->
    $(@appendTo).append(@$el)

    @positionElement()

    @$el.fadeIn @options.fade_time, =>
      setTimeout(@remove, @options.in_screen_time)

  positionElement: ->
    @$el.css
      top: '65px',
      left: '50%',
      marginLeft: "-#{@$el.width()/2}px"

  remove: =>
    @$el.fadeOut(@options.fade_time, => @$el.remove())

FACTLINK.Views.Notifications.showFactlinkCreated = ->
  FACTLINK.Views.Notifications.show
    message: 'Factlink posted!'
    type_classes: 'fl-message-success fl-message-icon-logo'

FACTLINK.Views.Notifications.showShouldSelectText = ->
  FACTLINK.Views.Notifications.show
    message: 'To create a Factlink, select a statement and click the Factlink button.'
    type_classes: 'fl-message-icon-add'

FACTLINK.Views.Notifications.showLoaded = ->
  FACTLINK.Views.Notifications.show
    message: 'Factlink is loaded!'
    type_classes: 'fl-message-success fl-message-icon-time'

FACTLINK.Views.Notifications.show = (options) ->
  message = new FACTLINK.Views.Notification options
  message.render()
