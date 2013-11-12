Backbone.Factlink ||= {}

class Backbone.Factlink.SemiPersistentTextModel extends Backbone.Model
  constructor: (attributes, options) ->
    super

    @set 'text', sessionStorage?[options.key] ? ''
    @on 'change:text', (model, value) ->
      sessionStorage[options.key] = value if sessionStorage?
