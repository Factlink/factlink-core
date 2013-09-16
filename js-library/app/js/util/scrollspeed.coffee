scroll_speed = new Factlink.Speedmeter(1.0)

speeding_attention = new Factlink.AttentionSpan
  wait_for_attention: 50
  wait_for_neglection: 50
  onAttentionGained: =>
    Factlink.el.trigger('start_fast_scrolling') unless Factlink.el.hasClass 'fl-fast-scrolling'
  onAttentionLost: =>
    Factlink.el.trigger('stop_fast_scrolling') if Factlink.el.hasClass 'fl-fast-scrolling'


recheckWhetherWereStillScrolling = null;

check_scrolling_speed = =>
    clearTimeout recheckWhetherWereStillScrolling
    scrolltop = if window.pageYOffset?
                  window.pageYOffset
                else if  document.documentElement.scrollTop?
                  document.documentElement.scrollTop
                else
                  document.body.scrollTop

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

Factlink.el.on
  start_fast_scrolling: =>
    Factlink.el.addClass 'fl-fast-scrolling'
    Factlink.el.trigger 'started_fast_scrolling'
  stop_fast_scrolling: =>
    Factlink.el.removeClass 'fl-fast-scrolling'
    Factlink.el.trigger 'stopped_fast_scrolling'
