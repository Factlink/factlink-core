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

  show_number_of_users: 6

  initialize: (options) ->
    @collection = @model.opinionaters()
    @bindTo @collection, 'add remove reset', @render

  appendHtml: (collectionView, itemView, index) ->
    super if index < @show_number_of_users

  templateHelpers: =>
    numberNotDisplayed: => Math.max(0, @collection.totalRecords - @show_number_of_users)

  show_all: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @show_number_of_users = Infinity
    @collection.howManyPer(1000000)
    @collection.fetch()
