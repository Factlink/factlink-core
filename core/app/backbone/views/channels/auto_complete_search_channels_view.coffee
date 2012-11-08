#= require ../auto_complete/search_list_view

class AutoCompleteSearchChannelView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "channels/auto_complete_search_channel"

  initialize: ->
    @queryRegex = new RegExp(@options.query, "gi")

  templateHelpers: ->
    view = this

    highlightedTitle: ->
      htmlEscape(@title).replace(view.queryRegex, "<em>$&</em>")

  onRender: ->
    @$el.addClass('user-logo') if @model.existingChannelFor(currentUser)

class window.AutoCompleteSearchChannelsView extends AutoCompleteSearchListView
  itemView: AutoCompleteSearchChannelView
