class window.FeedActivities extends Backbone.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp
  model: Activity

  url: -> '/api/beta/feed'
