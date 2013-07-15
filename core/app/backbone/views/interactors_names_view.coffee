class NDPInteractorNameView extends Backbone.Marionette.Layout
  tagName: 'span'
  className: 'separator-list-item'
  template: 'fact_relations/interactor_name'

class window.NDPInteractorNamesView extends Backbone.Marionette.CompositeView
  template: 'fact_relations/ndp_interactors_names'
  itemView: NDPInteractorNameView
  itemViewContainer: ".js-interactors-collection"
  # emptyView: InteractorEmptyView

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
    translation = switch @collection.type
      when 'weakening' then "fact_disbelieve_present_#{multiplicity}_action"
      when 'supporting' then "fact_believe_present_#{multiplicity}_action"
      when 'doubting' then "fact_doubt_present_#{multiplicity}_action"

    past_action: Factlink.Global.t[translation]

  showAll: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @collection.howManyPer(1000000)
    @fetch()
