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

  initialEvents: ->
    @bindTo @collection, 'add remove reset', @render, @

  template:
    text: """
      <table>
        <tr class="js-row-my hide">
          <th>My channels</th>
          <td><ul class="js-list-my"></ul></td>
        </tr>
        <tr class="js-row-all hide">
          <th>Topics</th>
          <td><ul class="js-list-all"></ul></td>
        </tr>
        <tr class="js-row-new hide">
          <td colspan="2"><ul class="js-list-new"></ul></td>
        </tr>
      </table>
    """

  appendHtml: (collectionView, itemView, index) ->
    model = itemView.model
    if not model.get('new') and model.existingChannelFor(currentUser)
      @$('.js-list-my').append itemView.el
      @$('.js-row-my').removeClass 'hide'
    else if not model.get('new')
      @$('.js-list-all').append itemView.el
      @$('.js-row-all').removeClass 'hide'
    else
      @$('.js-list-new').append itemView.el
      @$('.js-row-new').removeClass 'hide'
