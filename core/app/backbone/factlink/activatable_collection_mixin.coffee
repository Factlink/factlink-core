Backbone.Factlink ||= {}

Backbone.Factlink.ActivatableCollectionMixin =
  unsetActive: ->
    return unless @_activeId?

    active = @getActive()
    delete @_activeId
    active?.trigger "deactivate"

  setActive: (model) ->
    return if @isActive(model)

    @unsetActive()
    @_activeId = model.id
    @getActive()?.trigger 'activate'

  isActive: (model) -> model.id == @_activeId

  getActive: -> @get(@_activeId)
