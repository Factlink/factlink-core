class InteractingUsersAvatarView extends Backbone.Marionette.Layout
  tagName: 'li'
  className: 'discussion-interacting-users-avatar'
  template: 'interacting_users/avatar'

  onRender: ->
    Backbone.Factlink.makeTooltipForView @,
      positioning: {align: 'left', side: 'bottom'}
      selector: '.js-user-avatar'
      tooltipViewFactory: => new UserPopoverContentView model: @model


class window.InteractingUsersAvatarsView extends Backbone.Marionette.CompositeView
  className: 'discussion-interacting-users-avatars'
  template: "interacting_users/avatars"
  itemView: InteractingUsersAvatarView

  itemViewContainer: ".js-interactor-avatars-collection"

  events:
    'click .js-show-all' : 'show_all'

  number_of_items: 7

  initialize: (options) ->
    @listenTo @collection, 'add remove reset sync', @render

  _initialEvents: -> # don't use default bindings to collection

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
