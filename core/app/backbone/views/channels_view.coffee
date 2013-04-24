class ChannelItemView extends Backbone.Marionette.ItemView
  tagName: "li"

  template: "channels/_single_menu_item"

  initialize: ->
    @addClassToggle('active')

    @model.bind('activate', @activeOn, this)
    @model.bind('deactivate', @activeOff, this)
    @model.bind('change',@render,this)

  onRender: ->
    @activeOn() if @model.isActive

_.extend ChannelItemView.prototype, ToggleMixin

class window.ChannelHeaderView extends Backbone.Marionette.ItemView
  tagName: "ul"
  className: "channel-listing"

  template: 'channels/list_header'

  templateHelpers: =>
    channel_listing_header: Factlink.Global.t.topics.capitalize()

class window.ChannelListView extends Backbone.Marionette.CollectionView
  itemView: ChannelItemView
  tagName: 'ul'
  id: 'channel-listing'
  className: 'channel-listing'

class window.ChannelsView extends Backbone.Marionette.Layout
  template: 'channels/channel_list'
  className: 'channel-listing-container-container'

  regions:
    list:   '.channel-listing-container'
    header: '.channel-listing-header'

  initialize: ->
    @bindTo @collection, 'reset', @setUserFromChannels, this

  onRender: ->
    @list.show new ChannelListView(collection: @collection)
    @header.show new ChannelHeaderView(@options)

  setActiveChannel: (channel)->
    if channel?
      @collection.setActiveChannel(channel)
    else
      @unsetActive()


  # we use setActive to indicate which type is active
  # this is to be used when something other than a channel is
  # activated. If the type has no specific element to activate,
  # everything is deactivated
  setActive: (type) ->
    @collection.unsetActiveChannel()
    @header.currentView.trigger 'activate', type

  unsetActive: ->
    @setActive()
