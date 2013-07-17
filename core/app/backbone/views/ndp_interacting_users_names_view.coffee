class NDPInteractingUsersNameView extends Backbone.Marionette.Layout
  tagName: 'span'
  className: 'ndp-interacting-users-name separator-list-item'
  template: 'fact_relations/interactor_name'

class window.NDPInteractingUsersNamesView extends Backbone.Marionette.CompositeView
  className: 'ndp-interacting-users-names'
  template: 'fact_relations/ndp_interactors_names'
  itemView: NDPInteractingUsersNameView
  itemViewContainer: ".js-interactors-collection"

  events:
    'click a.js-show-all' : 'show_all'

  number_of_items: 3

  initialize: (options) ->
    @collection = @model.opinionaters()
    @bindTo @collection, 'add remove reset', @render

  appendHtml: (collectionView, itemView, index) ->
    super if index < @truncatedList().number

  templateHelpers: =>
    multiplicity = if @collection.totalRecords > 1 then 'plural' else 'singular'
    translation = "fact_#{@collection.type}_present_#{multiplicity}_action"
    truncatedList = @truncatedList()

    past_action: Factlink.Global.t[translation]
    numberOfOthers: @collection.totalRecords - truncatedList.number
    showOthers: truncatedList.others

  truncatedList: ->
    truncateList @collection.totalRecords, @number_of_items

  show_all: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @number_of_items = Infinity
    @collection.howManyPer(1000000)
    @collection.fetch()
