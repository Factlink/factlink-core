class Factlink.Balloon
  constructor: (dom_events={}) ->
    @$el = $(Factlink.templates.indicator)
    @$el.appendTo(Factlink.el)
    for event, callback of dom_events
      @$el.bind event, callback

  show: (top, left) ->
    Factlink.el.find('div.fl-popup').removeClass('active')
    @$el.addClass 'active'
    Factlink.set_position_of_element top, left, window, @$el

  hide: (callback) ->
    @$el.removeClass 'active'
    setTimeout (=> callback(@)), 400

  destroy: -> @$el.remove()

  startLoading: -> @$el.addClass "fl-loading"
