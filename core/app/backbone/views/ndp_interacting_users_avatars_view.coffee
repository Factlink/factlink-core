class NDPInteractingUsersAvatarView extends Backbone.Marionette.Layout
  tagName: 'li'
  className: 'interactor-avatar user-avatar'
  template: 'fact_relations/interactor_avatar'

class window.NDPInteractingUsersAvatarsView extends Backbone.Marionette.CompositeView
  className: 'ndp-interacting-users-avatars'
  template: "fact_relations/ndp_interactors_avatars"
  itemView: NDPInteractingUsersAvatarView

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
