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

  template:
    text: """
      <table>
        <tr class="js-row-my">
          <th>My channels</th>
          <td><ul class="js-list-my"></ul></td>
        </tr>
        <tr class="js-row-all">
          <th>Topics</th>
          <td><ul class="js-list-all"></ul></td>
        </tr>
        <tr class="js-row-new">
          <td colspan="2"><ul class="js-list-new"></ul></td>
        </tr>
      </table>
    """

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
