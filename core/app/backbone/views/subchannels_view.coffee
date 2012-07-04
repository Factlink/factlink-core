class window.SubchannelsView extends Backbone.Factlink.CompositeView
  tagName: "div"
  id: "contained-channels"
  template: "channels/subchannels"
  itemView: SubchannelItemView
  events:
    "click #more-button": "toggleMore"
    "composite:collection:rendered": "setStateForCurrentNumberOfModels"
  nrOfInitialVisibleItems: 3

  initialize: ->
    @collection.bind "remove", @renderCollection, this

  toggleMore: ->
    button = @$("#more-button .label")
    @$(".overflow").slideToggle (e) ->
      button.text (if button.text() is "more" then "less" else "more")

  appendHtml: (collectView, itemView) ->
    @$(".contained-channel-description").show()
    if @$("ul").children().length < @nrOfInitialVisibleItems + 1
      @$("ul").prepend itemView.el
    else
      @$(".overflow").append itemView.el
      $("#more-button").show()

  onRender: => @setStateForCurrentNumberOfModels()

  setStateForCurrentNumberOfModels: ->
    if @collection.models.length is 0
      @$(".contained-channel-description").hide()
    if @collection.models.length <= @nrOfInitialVisibleItems
      $("#more-button").hide()
