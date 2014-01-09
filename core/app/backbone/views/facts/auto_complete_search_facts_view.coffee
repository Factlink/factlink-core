#= require ../auto_complete/search_list_view

class AutoCompleteSearchFactView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "facts/auto_complete_search_fact"

  templateHelpers: ->
    query = @options.query

    highlighted_title: -> highlightTextInTextAsHtml(query, @displaystring)

  scrollIntoView: -> scrollIntoViewWithinContainer @$el, @$el.parents('.auto-complete-search-list')

class window.AutoCompleteSearchFactsView extends AutoCompleteSearchListView
  itemView: AutoCompleteSearchFactView

  template: "facts/auto_complete_search_facts"

  ui:
    recent_list: '.js-list-recent'
    search_list: '.js-list-search'

    recent_row: '.js-row-recent'
    search_row: '.js-row-search'

  onRender: -> @updateRows()

  appendHtml: (collectionView, itemView, index) ->
    model = itemView.model
    if @options.recent_collection.get(model.id)?
      @ui.recent_list.append itemView.el
    else
      @ui.search_list.append itemView.el

    @updateRows()

  updateRows: ->
    @_updateRowActive @ui.recent_row, @ui.recent_list
    @_updateRowActive @ui.search_row, @ui.search_list

  _updateRowActive: ($row, $list) ->
    $row.toggleClass 'auto-complete-search-list-active', $list.find('li').length > 0
