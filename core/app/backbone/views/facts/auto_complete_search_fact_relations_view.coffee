#= require ../auto_complete/search_list_view

class AutoCompleteSearchFactRelationView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "facts/auto_complete_search_fact"

  initialize: ->
    @queryRegex = new RegExp(@options.query, "gi")

  templateHelpers: ->
    view = this

    highlightedTitle: ->
      htmlEscape(@displaystring).replace(view.queryRegex, "<em>$&</em>")

  onRender: ->
    # @$el.addClass('user-logo') if @model.id == currentUser.id

class window.AutoCompleteSearchFactRelationsView extends AutoCompleteSearchListView
  itemView: AutoCompleteSearchFactRelationView
