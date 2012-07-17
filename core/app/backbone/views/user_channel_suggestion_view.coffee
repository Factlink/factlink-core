class window.UserChannelSuggestionView extends Backbone.Marionette.ItemView
  template: "activities/_suggested_topic"
  tagName: "li"

  events:
    'click a.btn' : 'addModel'

  addModel: ->
    facts = @model.facts()
    facts.fetch
      success: =>
        @options.addToActivities.add(new Activity(
          {
            username: @model.get('created_by').username
          }
        ))
        console.info(facts.models[0])


    new_channel = @model.topic().newChannelForUser(window.currentUser)
    @options.addToCollection.add(new_channel)
    new_channel.save({},{
      success: =>
        @$('a.btn').hide()
        @model.collection = undefined
        new_channel.subchannels().add(@model)
        @model.save()
      error: =>
        @options.addToCollection.remove(model)
        alert('something went wrong while creating this channel')
    })

