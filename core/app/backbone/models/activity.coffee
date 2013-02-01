class window.Activity extends Backbone.Model
  getActivity: () ->
    new Activity(this)

  user: ->
    new User(this.get('user'))

class window.LastFactActivity extends Activity
  initialize: (options) -> @channel = options.channel

  url: ->
    if @collection
      super()
    else
      "#{@channel.normal_url()}/activities/last_fact.json"
