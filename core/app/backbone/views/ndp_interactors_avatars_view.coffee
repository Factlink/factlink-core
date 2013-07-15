class NDPInteractorAvatarView extends Backbone.Marionette.Layout
  tagName: 'li'
  className: 'interactor-avatar user-avatar'
  template: 'fact_relations/interactor_avatar'

  templateHelpers: => user: new User(@model).toJSON()

class window.NDPInteractorsAvatarView extends Backbone.Marionette.CompositeView
  template: "fact_relations/ndp_interactors_avatars"
  itemView: NDPInteractorAvatarView

  itemViewContainer: ".js-interactor-avatars-collection"

  events:
    'click .showAll' : 'showAll'

  initialize: (options) ->
    @collection.on 'reset', @render, @

  templateHelpers: =>
    numberNotDisplayed: => @collection.totalRecords - @collection.length

  showAll: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @collection.howManyPer(1000000)
    @collection.fetch()
