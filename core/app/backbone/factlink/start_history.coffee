Backbone.Factlink ||= {}

Backbone.Factlink.startHistory = ->
  $ ->
    Backbone.history.start pushState:Modernizr.history
