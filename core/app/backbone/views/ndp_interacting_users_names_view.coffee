class InteractorEmptyView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: "fact_relations/interactor_empty"

class window.NDPInteractingUsersNamesView extends Backbone.Marionette.CompositeView
  template: 'fact_relations/ndp_interactors_names'
  itemView: InteractorNameView
  emptyView: InteractorEmptyView
  itemViewContainer: ".js-interactors-collection"

  events:
    'click a.js-show-all' : 'show_all'

  number_of_items: 3

  initialize: (options) ->
    @collection = @model.opinionaters()
    @bindTo @collection, 'add remove reset', @render

  appendHtml: (collectionView, itemView, index) ->
    return super if @collection.length == 0 # emptyview
    super if index < @truncatedListSizes().numberToShow

  templateHelpers: =>
    multiplicity = if @collection.totalRecords > 1
                     'plural'
                   else if @collection.at(0)?.is_current_user()
                     'singular_second_person'
                   else
                     'singular'
    translation = "fact_#{@collection.type}_past_#{multiplicity}_action"

    past_action: Factlink.Global.t[translation]
    numberOfOthers: @truncatedListSizes().numberOfOthers

  truncatedListSizes: ->
    truncatedListSizes @collection.totalRecords, @number_of_items

  #Possible method restrict names to one line: http://jsbin.com/esikiv/3/edit

  show_all: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @number_of_items = Infinity
    @collection.howManyPer(1000000)
    @collection.fetch()
