#= require ../auto_complete/search_list_view

highlightTextInTextAsHtml = (highlight, text)->
  highlightRegex = new RegExp(highlight, "gi")
  htmlEscape(text).replace(highlightRegex, "<em>$&</em>")

class AutoCompleteSearchChannelView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "channels/auto_complete_search_channel"

  scrollIntoView: -> scrollIntoViewWithinContainer @$el, $('.auto-complete-search-list')

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

    search_list_both:  '.auto-complete-search-list-last-rounded-both'
    search_list_right: '.auto-complete-search-list-last-rounded-right'

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
    myFilled  = @$('.js-list-my li').length > 0
    allFilled = @$('.js-list-all li').length > 0
    newFilled = @$('.js-list-new li').length > 0

    @_toggleSearchListActive(@ui.my_row, myFilled)
    @_toggleSearchListActive(@ui.all_row, allFilled)
    @_toggleSearchListActive(@ui.new_row, newFilled)

    @ui.search_list_both.removeClass  'auto-complete-search-list-last-rounded-both'
    @ui.search_list_right.removeClass 'auto-complete-search-list-last-rounded-right'

    if newFilled
      @ui.new_row.addClass 'auto-complete-search-list-last-rounded-both'
    else if allFilled
      @ui.all_row.addClass 'auto-complete-search-list-last-rounded-right'
    else
      @ui.my_row.addClass  'auto-complete-search-list-last-rounded-right'

  _toggleSearchListActive: (el, value) ->
    el.toggleClass  'auto-complete-search-list-active', value
