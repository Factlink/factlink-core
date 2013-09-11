class Factlink.AttentionSpan
  constructor: (@options={})->
    @_has_attention = false

  attend: ->
    clearTimeout @losing_attention_timeout
    @gaining_attention_timeout = setTimeout =>
      @gained_attention()
    , 300

  neglect: ->
    clearTimeout @gaining_attention_timeout
    @losing_attention_timeout = setTimeout =>
      @lost_attention()
    , 300

  has_attention: -> @_has_attention

  lost_attention: ->
    @_has_attention = false
    @options.lost_attention?()

  gained_attention: ->
    @_has_attention = true
    @options.gained_attention?()
