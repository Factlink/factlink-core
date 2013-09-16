count_object_or_null = (count) ->
  if count? then {count: count} else null

class window.UserStatisticsView extends Backbone.Marionette.ItemView
  className: 'statistics'
  template:
    text: """
      <div class="statistic">
        <span class="statistic-title">Following</span><br>
        {{#following}}{{ count }}{{/following}}
        {{^following}}<img src="{{global.ajax_loader_image}}">{{/following}}
      </div>
      <div class="statistic">
        <span class="statistic-title">Followers</span><br>
        {{#followers}}{{ count }}{{/followers}}
        {{^followers}}<img src="{{global.ajax_loader_image}}">{{/followers}}
      </div>
    """

  templateHelpers: =>
    following: count_object_or_null @model.following.length
    followers: count_object_or_null @model.followers.length

  initialize: ->
    @listenTo @model.followers, 'all', @render
    @listenTo @model.following, 'all', @render
    @model.followers.fetch()
    @model.following.fetch()
