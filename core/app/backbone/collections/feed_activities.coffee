class window.FeedActivities extends Backbone.Factlink.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp
  model: Activity

  initialize: (models, options) ->
    @_count = options.count || 20

  url: -> "/api/beta/feed.json?count=#{@_count}"
