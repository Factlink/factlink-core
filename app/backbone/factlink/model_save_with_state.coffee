Backbone.Factlink ||= {}
Backbone.Factlink.ModelSaveWithStateMixin =
  saveWithState: (attrs, options={}) ->
    @set save_failed: false

    @save attrs, _.extend {}, options,
      error: =>
        @set save_failed: true
        options.error?()
      statusCode:
        403: ->
          currentSession.user().fetch()
