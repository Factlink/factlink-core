Backbone.Factlink ||= {}

class Backbone.Factlink.Url
  constructor: (href) ->
    @element = document.createElement('a')
    @element.href = href

  host: -> @element.host
