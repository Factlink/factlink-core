class window.SubchannelsView extends Backbone.Factlink.CompositeView
  tagName: "div"
  id: "contained-channels"
  template: "channels/subchannels"
  itemView: SubchannelItemView
  events:
    "click #more-button": "toggleMore"

  initialize: ->
    @collection.bind "add remove reset", @updateVisibility, @
    @collection.bind "remove", @renderCollection, @

  toggleMore: ->
    button = @$("#more-button .label")
    @$(".overflow").slideToggle (e) ->
      button.text (if button.text() is "more" then "less" else "more")

  appendHtml: (collectView, itemView) ->
    @$(".contained-channel-description").show()
    @$("ul").prepend itemView.el

  updateVisibility: ->
    @$el.toggleClass 'hide', @collection.length <= 0
