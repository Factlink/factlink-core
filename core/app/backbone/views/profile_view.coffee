#= require './top_channel_view'

class window.ProfileView extends Backbone.Marionette.CompositeView
  template: "users/profile"
  className: "profile"
  itemView: TopChannelView
  itemViewContainer: ".top-channels ol"
  events:
    "click a.show-more": "showMoreOn"
    "click a.show-less": "showMoreOff"

  showMoreOn:  -> @$el.addClass 'showMore'
  showMoreOff: -> @$el.removeClass 'showMore'

  showEmptyView: ->
      @$(".top-channels").hide()
      @$(".no-channels").show()

  closeEmptyView: ->
      @$(".no-channels").hide()
      @$(".top-channels").show()

  onRender: ->
    @$(".top-channels .show-more").hide() if @collection.length < 6
