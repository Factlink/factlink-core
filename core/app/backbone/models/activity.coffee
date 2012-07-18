class window.Activity extends Backbone.Model
  getActivity: () ->
    new Activity(this)

class window.LastFactActivity extends Activity
  initialize: (options) -> @channel = options.channel

  url: -> "#{@channel.normal_url()}/last_fact_activity.json"