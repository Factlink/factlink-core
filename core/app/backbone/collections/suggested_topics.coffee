class window.SuggestedTopics extends Backbone.Collection
	model: Topic

	initialize: (topics, options) ->
		@user_url = options.user.url()

	url: -> @user_url + '/suggested_topics'