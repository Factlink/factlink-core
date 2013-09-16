getScrollTop = ->
  # copied this logic from inView
  # I assumed this supports some legacy browsers,
  # since this functionality is used in combination with
  # inView I want to support exactly the same browsers
  if window.pageYOffset?
    window.pageYOffset
  else if  document.documentElement.scrollTop?
    document.documentElement.scrollTop
  else
    document.body.scrollTop

scroll_speed = new Factlink.Speedmeter(1.0, getScrollTop())

speeding_attention = new Factlink.AttentionSpan
  wait_for_attention: 50
  wait_for_neglection: 50
  onAttentionGained: => Factlink.el.trigger 'fast_scrolling'
  onAttentionLost:   => Factlink.el.trigger 'slow_scrolling'


recheckWhetherWereStillScrolling = null;

check_scrolling_speed = =>
    clearTimeout recheckWhetherWereStillScrolling
    scrolltop = getScrollTop()

    scroll_speed.measure scrolltop
    if scroll_speed.is_fast()
      speeding_attention.gainAttention()
      # when scrolling sometimes we this suddenly stops without events
      # or we considered it fast still, while it actually wasn't anymore
      # so we need to recheck
      recheckWhetherWereStillScrolling = setTimeout check_scrolling_speed, 50
    else
      speeding_attention.loseAttention()

$(window).scroll check_scrolling_speed

# flag to ensure we only fire on state chaneg
currently_fast_scrolling = false
Factlink.el.on
  fast_scrolling: =>
    return if currently_fast_scrolling
    currently_fast_scrolling = true
    Factlink.el.addClass 'fl-fast-scrolling'
    Factlink.el.trigger 'started_fast_scrolling'
  slow_scrolling: =>
    return unless currently_fast_scrolling
    currently_fast_scrolling = false
    Factlink.el.removeClass 'fl-fast-scrolling'
    Factlink.el.trigger 'stopped_fast_scrolling'
