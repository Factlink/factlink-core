class window.SuggestedSiteTopics extends Backbone.Collection
  model: Topic

  initialize: (models, options) -> @site_id = options.site_id

  url: -> "/site/#{@site_id}/top_topics"
