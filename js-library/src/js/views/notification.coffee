Factlink.Views ||= {}

class Factlink.Views.Notification
  appendTo: '#fl'
  template: """
    <div class="fl-message">
      <div class="icon"></div><span></span>
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
    @$el.find('span').text(message)

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
