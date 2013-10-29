#= require ../auto_complete/search_list_view

class AutoCompleteSearchUserView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "users/auto_complete_search_user"

  templateHelpers: ->
    query = @options.query

    highlightedTitle: -> highlightTextInTextAsHtml(query, @name)

  onRender: ->
    @$el.addClass('user-logo') if @model.id == currentUser.id

class window.AutoCompleteSearchUsersView extends AutoCompleteSearchListView
  itemView: AutoCompleteSearchUserView
