#= require ../auto_complete/search_list_view

class AutoCompleteSearchFactRelationView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "fact_relations/auto_complete_search_fact_relation"

  ui:
    factWheel: '.js-fact-wheel'

  onRender: ->
    @ui.factWheel.html @wheelView().render().el

  wheelView: ->
    wheel = new Wheel @model.get("fact_wheel")
    new InteractiveWheelView
      fact: @model.get("fact_base")
      model: wheel
      interactive: false

  templateHelpers: ->
    query = @options.query

    highlightedTitle: -> highlightTextInTextAsHtml(query, @displaystring)

  scrollIntoView: -> scrollIntoViewWithinContainer @$el, @$el.parents('.auto-complete-search-list')

class window.AutoCompleteSearchFactRelationsView extends AutoCompleteSearchListView
  itemView: AutoCompleteSearchFactRelationView

  template: "fact_relations/auto_complete_search_fact_relations"

  ui:
    recent_list: '.js-list-recent'
    search_list:  '.js-list-search'

    recent_row: '.js-row-recent'
    search_row:  '.js-row-search'

  onRender: -> @updateRows()

  appendHtml: (collectionView, itemView, index) ->
    model = itemView.model
    if @options.recent_collection.get(model.id)?
      @ui.recent_list.append itemView.el
    else
      @ui.search_list.append itemView.el

    @updateRows()

  updateRows: ->
    recentFilled = @$('.js-list-recent li').length > 0
    searchFilled  = @$('.js-list-search li').length > 0

    @_toggleSearchListActive(@ui.recent_row, recentFilled)
    @_toggleSearchListActive(@ui.search_row, searchFilled)

  _toggleSearchListActive: (el, value) ->
    el.toggleClass  'auto-complete-search-list-active', value

