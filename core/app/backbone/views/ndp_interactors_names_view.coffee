class NDPInteractorNameView extends Backbone.Marionette.Layout
  tagName: 'span'
  className: 'separator-list-item'
  template: 'fact_relations/interactor_name'

class window.NDPInteractorNamesView extends Backbone.Marionette.CompositeView
  template: 'fact_relations/ndp_interactors_names'
  itemView: NDPInteractorNameView
  itemViewContainer: ".js-interactors-collection"

  events:
    'click a.js-show-all' : 'show_all'

  show_number_of_names: 2

  initialize: (options) ->
    @collection = @model.opinionaters()
    @collection.on 'add remove reset', @render, @

  appendHtml: (collectionView, itemView, index) ->
    super if index < @show_number_of_names

  templateHelpers: =>
    multiplicity = if @collection.totalRecords > 1 then 'plural' else 'singular'
    translation = "fact_#{@collection.type}_present_#{multiplicity}_action"

    past_action: Factlink.Global.t[translation]
    numberNotDisplayed: => @collection.totalRecords - @show_number_of_names
    multipleNotDisplayed: => (@collection.totalRecords - @show_number_of_names) > 1

  show_all: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @collection.howManyPer(1000000)
    @collection.fetch()
