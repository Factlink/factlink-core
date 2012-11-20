#= require ../auto_complete/search_list_view

class AutoCompleteSearchFactRelationView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "facts/auto_complete_search_fact"

  templateHelpers: ->
    query = @options.query

    highlightedTitle: -> highlightTextInTextAsHtml(query, @displaystring)

class window.AutoCompleteSearchFactRelationsView extends AutoCompleteSearchListView
  itemView: AutoCompleteSearchFactRelationView
