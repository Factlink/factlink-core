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

  number_of_items: 7

  initialize: (options) ->
    @bindTo @collection, 'add remove reset', @render

  appendHtml: (collectionView, itemView, index) ->
    super if index < @truncatedListSizes().numberToShow

  templateHelpers: =>
    numberOfOthers: @truncatedListSizes().numberOfOthers

  truncatedListSizes: ->
    truncatedListSizes @collection.totalRecords, @number_of_items

  show_all: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @number_of_items = Infinity
    @collection.howManyPer(1000000)
    @collection.fetch()
