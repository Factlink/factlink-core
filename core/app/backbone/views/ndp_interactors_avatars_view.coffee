class NDPInteractorAvatarView extends Backbone.Marionette.Layout
  tagName: 'li'
  className: 'interactor-avatar user-avatar'
  template: 'fact_relations/interactor_avatar'

class window.NDPInteractorsAvatarView extends Backbone.Marionette.CompositeView
  template: "fact_relations/ndp_interactors_avatars"
  itemView: NDPInteractorAvatarView

  itemViewContainer: ".js-interactor-avatars-collection"

  events:
    'click .js-show-all' : 'show_all'

  initialize: (options) ->
    @collection = @model.opinionaters()
    @collection.on 'add remove reset', @render, @

  templateHelpers: =>
    numberNotDisplayed: => @collection.totalRecords - @collection.length

  show_all: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @collection.howManyPer(1000000)
    @collection.fetch()
