Factlink.Views ||= {}

class Factlink.Views.Notification
  className: 'fl-message'
  tagName: 'div'
  appendTo: '#fl'

  default_options:
    in_screen_time: 2000
    fade_time: 'slow'

  constructor: (options) ->
    @options = $.extend {}, @default_options, options

  render: ->
    @$el = $("<#{@tagName}/>")
              .addClass(@className)
              .hide()
              .text(@options.message)

    $(@appendTo).append(@$el)

    @$el.fadeIn @options.fade_time, =>
      setTimeout(@remove, @options.in_screen_time)

  remove: =>
    @$el.fadeOut(@options.fade_time, => @$el.remove())
