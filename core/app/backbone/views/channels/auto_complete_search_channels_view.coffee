#= require ../auto_complete/search_list_view

highlightTextInTextAsHtml = (highlight, text)->
  highlightRegex = new RegExp(highlight, "gi")
  htmlEscape(text).replace(highlightRegex, "<em>$&</em>")

class AutoCompleteSearchChannelView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "channels/auto_complete_search_channel"

  templateHelpers: ->
    query = @options.query

    highlightedTitle: -> highlightTextInTextAsHtml(query, @title)

class window.AutoCompleteSearchChannelsView extends AutoCompleteSearchListView
  itemView: AutoCompleteSearchChannelView

  template: "channels/auto_complete_search_channels"

  ui:
    my_list:  '.js-list-my'
    all_list: '.js-list-all'
    new_list: '.js-list-new'

    my_row:  '.js-row-my'
    all_row: '.js-row-all'
    new_row: '.js-row-new'

  onRender: -> @updateRows()

  appendHtml: (collectionView, itemView, index) ->
    model = itemView.model
    if not model.get('new') and model.existingChannelFor(currentUser)
      @ui.my_list.append itemView.el
    else if not model.get('new')
      @ui.all_list.append itemView.el
    else
      @ui.new_list.append itemView.el

    @updateRows()

  updateRows: ->
    myFilled = @$('.js-list-my li').length > 0
    allFilled = @$('.js-list-all li').length > 0
    newFilled = @$('.js-list-new li').length > 0

    @ui.my_row.toggleClass  'auto-complete-search-list-active', myFilled
    @ui.all_row.toggleClass 'auto-complete-search-list-active', allFilled
    @ui.new_row.toggleClass 'auto-complete-search-list-active', newFilled

    @$('.auto-complete-search-list-last-rounded-both').removeClass 'auto-complete-search-list-last-rounded-both'
    @$('.auto-complete-search-list-last-rounded-right').removeClass 'auto-complete-search-list-last-rounded-right'

    if newFilled
      @ui.new_row.addClass 'auto-complete-search-list-last-rounded-both'
    else if allFilled
      @ui.all_row.addClass 'auto-complete-search-list-last-rounded-right'
    else
      @ui.my_row.addClass  'auto-complete-search-list-last-rounded-right'
