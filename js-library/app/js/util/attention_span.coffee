class Factlink.AttentionSpan
  constructor: (@options={})->
    @_has_attention = false
    @options.wait_for_attention ?= 0
    @options.wait_for_neglection ?= 0
  attend: ->
    clearTimeout @losing_attention_timeout
    @gaining_attention_timeout = setTimeout =>
      @gained_attention()
    , @options.wait_for_attention

  neglect: ->
    clearTimeout @gaining_attention_timeout
    @losing_attention_timeout = setTimeout =>
      @lost_attention()
    , @options.wait_for_neglection

  has_attention: -> @_has_attention

  lost_attention: ->
    @_has_attention = false
    @options.lost_attention?()

  gained_attention: ->
    @_has_attention = true
    @options.gained_attention?()
