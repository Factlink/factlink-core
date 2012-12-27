Backbone.Factlink ||= {}

Backbone.Factlink.AlertMixin =
  alertShow: (type) ->
    @alertHide()
    @$('.js-alert-' + type).removeClass 'hide'

  alertHide: ->
    @$('.js-alert').addClass 'hide'

  alertErrorInit: (errorTypes) ->
    @alertErrorTypes = errorTypes

  alertError: (errorType) ->
    if @alertErrorTypes? and errorType? in @alertErrorTypes
      @alertShow 'error-' + errorType
    else
      @alertShow 'error'

  alertBindErrorEvent: (object) ->
    @bindTo object, 'error', (errorType) => @alertError errorType

# We could refactor this later to use language strings instead of <div> elements
# that we show and hide.
