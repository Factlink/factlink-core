#= require './top_channels_view'

class window.ProfileInformationView extends Backbone.Marionette.ItemView
  template: "users/profile/information"

class window.ProfileView extends Backbone.Marionette.Layout
  template:  'users/profile/index'
  className: 'profile'

  ui:
    topChannelsRegion: '.js-top-channels-region'

  regions:
    topChannelsRegion:        '.js-top-channels-region'
    profileInformationRegion: '.profile-information'
    factRegion:               '.fact-region'

  initialize: ->

  onRender: ->
    @profileInformationRegion.show  new ProfileInformationView(model: @model)
    @factRegion.show                @options.created_facts_view
    @_showTopChannelsView()

  _showTopChannelsView: ->
    return unless Factlink.Global.signed_in

    orderedCollection = @_ordered(@collection)
    @ui.topChannelsRegion.show()

    @topChannelsRegion.show new TopChannelsView
      collection: orderedCollection
      originalCollection: @collection
      user: @model

  _ordered: (collection)->
    ordered_channels = new ChannelList()
    ordered_channels.orderByAuthority()

    @listenTo @collection, 'sync', =>
      ordered_channels.reset @collection.models
    ordered_channels.reset @collection.models

    ordered_channels
