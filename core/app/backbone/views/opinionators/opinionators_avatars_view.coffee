class OpinionatorsAvatarView extends Backbone.Marionette.Layout
  tagName: 'span'
  className: 'opinionators-avatar'
  template: 'opinionators/avatar'

  onRender: ->
    UserPopoverContentView.makeTooltip @, @model

class window.OpinionatorsAvatarsView extends Backbone.Marionette.CompositeView
  tagName: 'span'
  className: 'opinionators-avatars'
  template: "opinionators/avatars"
  itemView: OpinionatorsAvatarView

  itemViewContainer: ".js-opinionators-avatars-collection"

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
    @render()
