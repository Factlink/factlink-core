#=require ./suggested_topic_view.coffee

class window.SuggestedTopicsView extends Backbone.Marionette.CompositeView
  className: 'empty_stream_content'
  template: "activities/empty"
  itemViewContainer: "ul"
  itemView: SuggestedTopicView
  
  itemViewOptions: => addToCollection : window.Channels

  showEmptyView: ->
    @$(".empty-list-message").show()

  closeEmptyView: ->
    @$(".empty-list-message").hide()
