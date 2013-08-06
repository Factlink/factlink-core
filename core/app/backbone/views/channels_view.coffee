class ChannelItemView extends Backbone.Marionette.ItemView
  _.extend @prototype, ClassToggleMixin('active')

  tagName: 'li'
  className: 'sidebar-item'
  template: 'channels/single_menu_item'

  initialize: ->
    @model.on 'activate', @activeOn, @
    @model.on 'deactivate', @activeOff, @

  onRender: ->
    @activeOn() if @model.isActive()

class window.ChannelHeaderView extends Backbone.Marionette.ItemView
  tagName: 'ul'
  template: 'channels/list_header'

  templateHelpers: =>
    channel_listing_header: Factlink.Global.t.topics.capitalize()

class window.ChannelListView extends Backbone.Marionette.CollectionView
  itemView: ChannelItemView
  tagName: 'ul'

class window.ChannelsView extends Backbone.Marionette.Layout
  template: 'channels/channel_list'
  className: 'left-sidebar'

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
      @collection.setActive(channel)
    else
      @collection.unsetActive()
