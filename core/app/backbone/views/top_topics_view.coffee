#=require ./top_topic_view.coffee

class window.TopTopicsView extends Backbone.Marionette.CompositeView
  className: 'empty_stream_content'
  template: "activities/empty"
  itemViewContainer: "ul"
  itemView: TopTopicView

  itemViewOptions: => addToCollection : window.Channels

  showEmptyView: ->
    @$(".empty-list-message").show()

  closeEmptyView: ->
    @$(".empty-list-message").hide()
