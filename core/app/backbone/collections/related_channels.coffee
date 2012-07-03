class window.RelatedChannels extends Backbone.Collection
	initialize: (channels, options) -> 
		@options = options
	url: ->
		@options.forChannel.get('topic_url') + '/related_user_channels'
	model: Channel