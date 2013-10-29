Backbone.Factlink ||= {}

class Backbone.Factlink.LocalStorageTextModel extends Backbone.Model
  constructor: (attributes, options) ->
    super

    @set 'text', localStorage?[options.key] ? ''
    @on 'change:text', (model, value) ->
      localStorage[options.key] = value if localStorage?
