balloon_fade_in_time = 2000
balloon_fade_out_time = 2000

class Factlink.Balloon
  constructor: (dom_events={}) ->
    @$el = $(Factlink.templates.indicator)
    @$el.appendTo(Factlink.el)
    for event, callback of dom_events
      @$el.bind event, callback

  show: (top, left) ->
    Factlink.el.find('div.fl-popup').hide()
    @$el.fadeIn balloon_fade_in_time
    Factlink.set_position_of_element top, left, window, @$el

  hide: (callback) -> @$el.fadeOut balloon_fade_out_time, => callback()

  destroy: -> @$el.remove()

  startLoading: -> @$el.addClass "fl-loading"
