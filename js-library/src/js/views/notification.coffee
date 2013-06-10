Factlink.Views ||= {}

class Factlink.Views.Notification
  className: 'fl-message'
  tagName: 'div'
  appendTo: '#fl'

  default_options:
    in_screen_time: 2000
    fade_time: 'slow'

  constructor: (options) ->
    @options = _.extend {}, @default_options, options

    @$el = $("<#{@tagName}/>")
          .addClass(@className)
          .hide()
          .text(@options.message)

  render: ->
    $(@appendTo).append(@$el)

    @$el.fadeIn @options.fade_time, =>
      setTimeout(@remove, @options.in_screen_time)

  remove: =>
    @$el.fadeOut(@options.fade_time, => @$el.remove())
