#= require './top_channel_view'

class window.ProfileInformationView extends Backbone.Marionette.ItemView
  template: "users/profile/information"

class window.ProfileView extends Backbone.Marionette.Layout
  template:  'users/profile/index'
  className: 'profile'

  regions:
    topChannelsRegion:        '.top-channels-region'
    profileInformationRegion: '.profile-information'
    factRegion:               '.fact-region'

  onRender: ->
    @topChannelsRegion.show         new TopChannelView(collection: @collection)
    @profileInformationRegion.show  new ProfileInformationView(model: @model)
    @factRegion.show                @getFactsView( @getChannel() )

  getChannel: ->
    new Channel(id: @model.get('created_facts_channel_id'), created_by: { username: @model.get('username') } )

  getFactsView: (channel) ->
    return new FactsView(
      collection: new ChannelFacts([],
        channel: channel
      ),
      model: channel
    )
