class window.UserChannelSuggestionView extends Backbone.Marionette.ItemView
  template: "channels/_suggested_user_channel"
  tagName: "li"

  events:
    'click a.btn' : 'addChannel'

  addChannel: ->
    @trigger 'added'
    aantal_callbacks = 0
    activity = undefined
    channel = undefined

    na_beide = =>
      aantal_callbacks++
      activityCollection = @options.addToActivities
      if (aantal_callbacks == 2 )
        channel.on 'destroy', -> activityCollection.remove(activity)

    @addActivityToStream
      success: (act)->
        activity = act
        na_beide()
    @createNewChannelWithSubchannel
      success: (ch)=>
        @$('a.btn').hide()
        channel = ch
        na_beide()
      error: -> alert('something went wrong while creating this channel')

  addActivityToStream: (options)->
    last_fact_activity = @model.lastAddedFactAsActivity()
    last_fact_activity.fetch
      success: =>
        @options.addToActivities.unshift(last_fact_activity)
        options.success(last_fact_activity)
      error: => options.error() if options.error


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
          success: => options.success(new_channel) if options.success
          error: error_function
      error: => error_function
