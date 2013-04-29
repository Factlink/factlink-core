ActivatableCollection =
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

  isActive: (model) ->
    model.id == @_activeId

  getActive: -> @get(@_activeId)



class window.FavouriteTopics extends Backbone.Collection

  model: Topic

  url: -> "/#{currentUser.get('username')}/favourite_topics"

_.extend window.FavouriteTopics.prototype, ActivatableCollection
