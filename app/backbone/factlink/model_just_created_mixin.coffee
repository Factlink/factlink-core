Backbone.Factlink ||= {}
Backbone.Factlink.ModelJustCreatedMixin =
  justCreated: ->
    milliseconds_ago = Date.now() - new Date(@get('created_at'))
    minutes_ago = milliseconds_ago/1000/60

    minutes_ago < 10
