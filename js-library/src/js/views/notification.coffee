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
    in_screen_time: 2000
    fade_time: 'slow'
    type_classes: ''

  constructor: (options) ->
    @options = _.extend {}, @default_options, options

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

Factlink.Views.Notifications.showFactlinkCreated = ->
  created_message = new Factlink.Views.Notification
    message: 'Factlink loaded!'
    type_classes: 'fl-message-success fl-message-icon-time'

  created_message.render()
