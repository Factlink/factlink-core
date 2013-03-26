class window.SuggestedSiteTopics extends Backbone.Collection
  model: Topic

  initialize: (models, options) -> @site_url = options.site_url

  url: -> "/site/top_topics"

  fetch: (options) ->
    if @site_url
      new_options = _.extend({}, options, data: {url: @site_url})
      super new_options
