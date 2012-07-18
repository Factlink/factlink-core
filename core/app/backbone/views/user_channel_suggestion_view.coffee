class window.UserChannelSuggestionView extends Backbone.Marionette.ItemView
  template: "activities/_suggested_topic"
  tagName: "li"

  events:
    'click a.btn' : 'addChannel'

  addChannel: ->
    @addActivityToStream()
    @createNewChannelWithSubchannel
      success: => @$('a.btn').hide()
      error: -> alert('something went wrong while creating this channel')

  addActivityToStream: ->
    last_fact_activity = @model.lastAddedFactAsActivity()
    last_fact_activity.fetch
      success: =>
        @options.addToActivities.unshift(last_fact_activity)

  createNewChannelWithSubchannel: (options) ->
    new_channel = @model.topic().newChannelForUser(window.currentUser)
    @options.addToCollection.add(new_channel)

    error_function = =>
      @options.addToCollection.remove(model)
      options.error() if options.error

    new_channel.save {},
      success: =>
        @model.collection = undefined
        new_channel.subchannels().add(@model)
        @model.save {},
          success: => options.success() if options.success
          error: error_function
      error: => error_function
