Factlink.Views ||= {}
Factlink.Views.Notifications ||= {}

class Factlink.Views.Notification
  appendTo: '#fl'
  template: """
    <div class="fl-message">
      <div class="fl-message-icon"></div><span class="fl-message-content fl-js-message"></span>
    </div>
  """

  default_options:
    in_screen_time: 1000
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
    @$el.addClass 'active'
    @$el.addClass 'been-active'
    setTimeout(@remove, @options.in_screen_time)

  positionElement: ->
    @$el.css
      top: '65px',
      left: '50%',
      marginLeft: "-#{@$el.width()/2}px"

  remove: =>
    @$el.removeClass 'active'

show = (options) ->
  message = new Factlink.Views.Notification options
  message.render()

Factlink.showFactlinkCreatedNotification = ->
  show
    message: 'Factlink posted!'
    type_classes: 'fl-message-success fl-message-icon-logo'
    in_screen_time: 1000

Factlink.showShouldSelectTextNotification = ->
  show
    message: 'To create a Factlink, select a statement and click the Factlink button.'
    type_classes: 'fl-message-icon-add'
    in_screen_time: 3000

Factlink.showLoadedNotification = ->
  show
    message: 'Factlink is loaded!'
    type_classes: 'fl-message-success fl-message-icon-time'
    in_screen_time: 3000
