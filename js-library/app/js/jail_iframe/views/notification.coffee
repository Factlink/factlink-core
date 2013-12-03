FactlinkJailRoot.Views ||= {}
FactlinkJailRoot.Views.Notifications ||= {}

class FactlinkJailRoot.Views.Notification
  template: """
    <div class="fl-message">
      <div class="fl-message-icon"></div><span class="fl-message-content fl-js-message"></span>
    </div>
  """

  constructor: (@options={}) ->
    @$el = $(@template)
    @$el.addClass(@options.type_classes)
    @setMessage(@options.message)

  setMessage: (message) ->
    @$el.find('.fl-js-message').text(message)

  render: ->
    FactlinkJailRoot.$factlinkCoreContainer.append(@$el)
    @positionElement()

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
    setTimeout (=> @$el.remove()), 2000 # Should be larger than @notification_transition_time

show = (options) ->
  message = new FactlinkJailRoot.Views.Notification options
  message.render()

FactlinkJailRoot.showFactlinkCreatedNotification = ->
  show
    message: 'Factlink posted!'
    type_classes: 'fl-message-success fl-message-icon-logo'
    in_screen_time: 1000

FactlinkJailRoot.showShouldSelectTextNotification = ->
  show
    message: 'To create a Factlink, select a statement and click the Factlink button.'
    type_classes: 'fl-message-icon-add'
    in_screen_time: 3000

FactlinkJailRoot.showLoadedNotification = ->
  show
    message: 'Factlink is loaded!'
    type_classes: 'fl-message-success fl-message-icon-time'
    in_screen_time: 3000
