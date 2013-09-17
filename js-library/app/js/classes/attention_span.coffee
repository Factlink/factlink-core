# Assumptions: the callbacks onAttentionLost and onAttentionGained are
#              idempotent

class Factlink.AttentionSpan
  constructor: (@options={})->
    @_has_attention = false
    @options.wait_for_attention ?= 0
    @options.wait_for_neglection ?= 0

  gainAttention: ->
    @clearTimeout 'losing_attention_timeout_handler'
    @gaining_attention_timeout_handler ?= setTimeout =>
      @gainAttentionNow()
    , @options.wait_for_attention

  loseAttention: ->
    @clearTimeout 'gaining_attention_timeout_handler'
    @losing_attention_timeout_handler ?= setTimeout =>
      @loseAttentionNow()
    , @options.wait_for_neglection

  has_attention: -> @_has_attention

  loseAttentionNow: ->
    @clearTimeout 'gaining_attention_timeout_handler'
    @clearTimeout 'losing_attention_timeout_handler'
    @_has_attention = false
    @options.onAttentionLost?()

  gainAttentionNow: ->
    @clearTimeout 'gaining_attention_timeout_handler'
    @clearTimeout 'losing_attention_timeout_handler'
    @_has_attention = true
    @options.onAttentionGained?()

  clearTimeout: (name) ->
    clearTimeout this[name]
    delete this[name]
