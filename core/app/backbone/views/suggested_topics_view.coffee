#=require ./suggested_topic_view.coffee

class window.SuggestedTopicsView extends Backbone.Marionette.CompositeView
  template: "activities/empty"

  itemViewContainer: "ul"

  events:
  	'click .done-button':'doneAdding'

  itemView: SuggestedTopicView
  itemViewOptions: => addToCollection : window.Channels

  doneAdding: ()->
  	this.trigger('done')
