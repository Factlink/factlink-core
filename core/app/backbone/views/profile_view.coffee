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

  initialize: ->
    @collection = @ordered(@collection)
  # TODO remove on updating marionette
  initialEvents: -> # don't rerender on collection change

  ordered: (collection)->
    ordered_channels = new ChannelList()
    ordered_channels.orderByAuthority()

    utils = new CollectionUtils(this)
    utils.updatedClone(ordered_channels, @collection)

    ordered_channels


  onRender: ->
    @topChannelsRegion.show         new TopChannelView(collection: @collection)
    @profileInformationRegion.show  new ProfileInformationView(model: @model)
    @factRegion.show                @options.created_facts_view
