class ChannelItemView extends Backbone.Marionette.ItemView
  tagName: "li"

  template: "channels/_single_menu_item"

  initialize: ->
    @addClassToggle('active')

    @model.bind('activate', @activeOn, this)
    @model.bind('deactivate', @activeOff, this)
    @model.bind('change',@render,this)

  onRender: ->
    @$el.attr('id', 'channel-' + @model.id)
    @activeOn() if @model.isActive

  templateHelpers: =>
    use_topic_url: @options.use_topic_url
    topic_url: @model.topicUrl()

_.extend ChannelItemView.prototype, ToggleMixin

class window.ChannelHeaderView extends Backbone.Marionette.ItemView
  tagName: "ul"
  className: "channel-listing"

  template: 'channels/list_header'

  templateHelpers: ->
    stream_title: -> Factlink.Global.t.stream.capitalize()
    channel_listing_header: ->
      Factlink.Global.t.topics.capitalize()
      
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
  itemViewOptions: -> use_topic_url: @options.use_topic_url

class window.ChannelsView extends Backbone.Marionette.Layout
  template: 'channels/channel_list'
  className: 'channel-listing-container-container'

  regions:
    list:   '.channel-listing-container'
    header: '.channel-listing-header'

  initialize: ->
    @bindTo @collection, 'reset', @setUserFromChannels, this

  onRender: ->
    @list.show new ChannelListView(collection: @collection, use_topic_url: @use_topic_url())
    @renderHeader()

  use_topic_url: ->
    # for now only use topic urls for your own pages
    @model.is_current_user()

  renderHeader: ->
    @header.show new ChannelHeaderView(model: @model, collection: @collection)

  setActiveChannel: (channel)->
    if not channel?
      @unsetActive()
    else if channel.get('is_all')
      @setActive('stream')
    else
      @collection.setActiveChannel(channel)


  # we use setActive to indicate which type is active
  # this is to be used when something other than a channel is
  # activated. If the type has no specific element to activate,
  # everything is deactivated
  setActive: (type) ->
    @collection.unsetActiveChannel()
    @header.currentView.trigger 'activate', type

  unsetActive: ->
    @setActive()
