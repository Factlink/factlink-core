#= require ../auto_complete/search_list_view

class AutoCompleteSearchUserView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "auto_complete/search_item"

  templateHelpers: ->
    query = @options.query

    highlightedTitle: -> highlightTextInTextAsHtml(query, @username)

  onRender: ->
    @$el.addClass('user-logo') if @model.id == currentUser.id

class window.AutoCompleteSearchUsersView extends AutoCompleteSearchListView
  itemView: AutoCompleteSearchUserView
