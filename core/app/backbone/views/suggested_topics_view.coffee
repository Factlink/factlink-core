#=require ./suggested_topic_view.coffee

class window.SuggestedTopicsView extends Backbone.Marionette.CompositeView
	template: "activities/empty"

	itemViewContainer: "ul"

	itemView: SuggestedTopicView