#=require ./suggested_topic_view.coffee

class window.emptyActivitiesView extends Backbone.Marionette.CompositeView
	template: "activities/empty"

	itemViewContainer: "ul"

	itemView: SuggestedTopicView