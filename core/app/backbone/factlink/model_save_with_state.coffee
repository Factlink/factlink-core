Backbone.Factlink ||= {}
Backbone.Factlink.ModelSaveWithStateMixin =
  saveWithState: (attrs, options={}) ->
    @set save_failed: false
    error = =>
      @set save_failed: true
      options.error?()

    @save attrs, _.extend(error: error, options)
