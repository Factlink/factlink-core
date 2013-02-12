#= require ../auto_complete/search_list_view

highlightTextInTextAsHtml = (highlight, text)->
  highlightRegex = new RegExp(highlight, "gi")
  htmlEscape(text).replace(highlightRegex, "<em>$&</em>")

class AutoCompleteSearchChannelView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "channels/auto_complete_search_channel"

  scrollIntoView: -> scrollIntoViewWithinContainer @$el, @$el.parents('.auto-complete-search-list')

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
    @_updateRowActive @ui.my_row, @ui.my_list
    @_updateRowActive @ui.all_row, @ui.all_list
    @_updateRowActive @ui.new_row, @ui.new_list

  _updateRowActive: ($row, $list) ->
    $row.toggleClass 'auto-complete-search-list-active', $list.find('li').length > 0
