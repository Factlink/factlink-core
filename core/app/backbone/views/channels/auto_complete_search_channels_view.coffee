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

  onRender: -> @updateRows()

  appendHtml: (collectionView, itemView, index) ->
    model = itemView.model
    if not model.get('new') and model.existingChannelFor(currentUser)
      @$('.js-list-my').append itemView.el
    else if not model.get('new')
      @$('.js-list-all').append itemView.el
    else
      @$('.js-list-new').append itemView.el

    @updateRows()

  updateRows: ->
    myFilled = @$('.js-list-my li').length > 0
    allFilled = @$('.js-list-all li').length > 0
    newFilled = @$('.js-list-new li').length > 0

    @$('.js-row-my').toggleClass 'auto-complete-search-list-active', myFilled
    @$('.js-row-all').toggleClass 'auto-complete-search-list-active', allFilled
    @$('.js-row-new').toggleClass 'auto-complete-search-list-active', newFilled

    @$('.auto-complete-search-list-last-rounded-both').removeClass 'auto-complete-search-list-last-rounded-both'
    @$('.auto-complete-search-list-last-rounded-right').removeClass 'auto-complete-search-list-last-rounded-right'

    if newFilled
      @$('.js-row-new').addClass 'auto-complete-search-list-last-rounded-both'
    else if allFilled
      @$('.js-row-all').addClass 'auto-complete-search-list-last-rounded-right'
    else
      @$('.js-row-my').addClass 'auto-complete-search-list-last-rounded-right'
