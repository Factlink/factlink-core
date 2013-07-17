#= require ./interactor_name_view

class InteractorEmptyView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: "fact_relations/interactor_empty"

class window.InteractorsView extends Backbone.Marionette.CompositeView
  template: "fact_relations/interactors"
  emptyView: InteractorEmptyView
  itemView: InteractorNameView
  itemViewContainer: ".js-interactors-collection"
  events:
    'click a.showAll' : 'showAll'

  initialize: (options) ->
    @model = new Backbone.Model
    @fetch()

  fetch: ->
    @collection.fetch success: =>
      @model.set
        numberNotDisplayed: @collection.totalRecords - @collection.length
        multipleNotDisplayed: (@collection.totalRecords - @collection.length)>1
      @render()

  templateHelpers: =>
    multiplicity = if @collection.totalRecords > 1 then 'plural' else 'singular'
    translation = "fact_#{@collection.type}_past_#{multiplicity}_action"

    past_action: Factlink.Global.t[translation]

  showAll: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @collection.howManyPer(1000000)
    @fetch()
