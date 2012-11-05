class ChannelItemView extends Backbone.Marionette.ItemView
  tagName: "li"

  template: "channels/_single_menu_item"

  initialize: () ->
    @addClassToggle('active')

    @model.bind('activate', @activeOn, this)
    @model.bind('deactivate', @activeOff, this)
    @model.bind('change',@render,this)

  onRender: () ->
    @$el.attr('id', 'channel-' + @model.id)
    @activeOn() if @model.isActive

_.extend ChannelItemView.prototype, ToggleMixin

class window.ChannelHeaderView extends Backbone.Marionette.ItemView
  tagName: "ul"
  className: "channel-listing"

  template: 'channels/list_header'

  templateHelpers: ->

    channel_listing_header: -> Factlink.Global.t.channels.capitalize()

  initialize: =>
    @on 'activate', (type)=> @activate(type)


  onRender: -> @renderActive()

  activate: (type) ->
    @_active = type
    @renderActive()

  renderActive: ->
    @$("li.#{@_active}").addClass('active') if @_active?

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
    @model = if @model? then @model.clone() else new User
    @setUserFromChannels()
    @bindTo @collection, 'reset', @setUserFromChannels, this

  setUserFromChannels: ->
    channel = window.Channels.first()
    @model.set(channel.user().attributes) if channel


  initialEvents: -> false # stop layout from refreshing after model/collection update
                    # no longer needed in marionette 1.0

  onRender: ->
    @list.show new ChannelListView(collection: @collection)
    @renderHeader()

  renderHeader: ->
    @header.show new ChannelHeaderView(model: @model, collection: @collection)

  setActiveChannel: (channel)->
    if channel.get('is_all')
      @setActive('stream')
    else
      @collection.setActiveChannel(channel)

  setActive: (type) ->
    @collection.unsetActiveChannel()
    @header.currentView.trigger 'activate', type

