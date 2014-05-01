class window.GlobalFeedActivities extends Backbone.Factlink.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp
  model: Activity

  initialize: (models, options={}) ->
    @_count = options.count || 20

  url: -> "/api/beta/feed.json?count=#{@_count}"

class window.DiscussionsFeedActivities extends Backbone.Factlink.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp
  model: Activity

  initialize: (models, options={}) ->
    @_count = options.count || 20

  url: -> "/api/beta/feed/discussions.json?count=#{@_count}"


class window.GroupActivities extends Backbone.Factlink.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp
  model: Activity

  initialize: (models, options) ->
    @group_id = options.group_id

  url: -> "/api/beta/groups/#{@group_id}/feed"


class window.PersonalFeedActivities extends Backbone.Factlink.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp
  model: Activity

  url: -> '/api/beta/feed/personal'
