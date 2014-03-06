class window.GlobalFeedActivities extends Backbone.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp
  model: Activity

  url: -> '/api/beta/feed'


class window.PersonalFeedActivities extends Backbone.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp
  model: Activity

  url: -> '/api/beta/feed/personal'
