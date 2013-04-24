class TopicItemView extends Backbone.Marionette.ItemView
  tagName: "li"

  template: "topics/sidebar/item"

  initialize: ->
    @addClassToggle('active')

    @model.bind('activate', @activeOn, this)
    @model.bind('deactivate', @activeOff, this)
    @model.bind('change',@render,this)

  onRender: ->
    @activeOn() if @model.isActive

  templateHelpers: =>
    topic_url: @model.topicUrl()

_.extend TopicItemView.prototype, ToggleMixin

class window.TopicHeaderView extends Backbone.Marionette.ItemView
  tagName: "ul"
  className: "channel-listing"

  template: 'topics/sidebar/header'

  templateHelpers: =>
    stream_title: Factlink.Global.t.stream.capitalize()
    channel_listing_header: Factlink.Global.t.favourites.capitalize()

  initialize: =>
    @on 'activate', (type)=> @activate(type)

  onRender: -> @renderActive()

  activate: (type) ->
    @_active = type
    @renderActive()

  renderActive: ->
    @$("li.#{@_active}").addClass('active') if @_active?

class window.TopicListView extends Backbone.Marionette.CollectionView
  itemView: TopicItemView
  tagName: 'ul'
  id: 'channel-listing'
  className: 'channel-listing'

class window.TopicSidebarView extends Backbone.Marionette.Layout
  template: 'topics/sidebar/layout'
  className: 'channel-listing-container-container'

  regions:
    list:   '.channel-listing-container'
    header: '.channel-listing-header'

  initialize: ->
    @bindTo @collection, 'reset', @setUserFromChannels, this

  onRender: ->
    @list.show new TopicListView(collection: @collection)
    @renderHeader()


  renderHeader: ->
    @header.show new TopicHeaderView(@options)

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
