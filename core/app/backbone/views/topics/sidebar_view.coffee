class TopicItemView extends Backbone.Marionette.ItemView
  _.extend @prototype, ClassToggleMixin('active')

  tagName: 'li'
  className: 'sidebar-item'
  template: 'topics/sidebar/item'

  initialize: ->
    @model.on 'activate', @activeOn, @
    @model.on 'deactivate', @activeOff, @

  onRender: -> @activeOn() if @model.isActive()

class window.TopicHeaderView extends Backbone.Marionette.ItemView
  tagName: 'ul'
  template: 'topics/sidebar/header'

  templateHelpers: =>
    stream_title: Factlink.Global.t.stream.capitalize()
    channel_listing_header: Factlink.Global.t.favourites.capitalize()

  initialize: =>
    @on 'activate', (type)=> @activate(type)
    @model = currentUser

  onRender: -> @renderActive()

  activate: (type) ->
    @_active = type
    @renderActive()

  renderActive: ->
    @$("li.js-#{@_active}").addClass('active') if @_active?

class window.TopicListView extends Backbone.Marionette.CollectionView
  itemView: TopicItemView
  tagName: 'ul'

class window.TopicSidebarView extends Backbone.Marionette.Layout
  template: 'topics/sidebar/layout'
  className: 'left-sidebar'

  regions:
    list:   '.channel-listing-container'
    header: '.channel-listing-header'

  onRender: ->
    @list.show new TopicListView(collection: @collection)
    @header.show new TopicHeaderView(@options)

  setActiveTopic: (topic)->
    if topic?
      @collection.setActive(topic)
    else
      @unsetActive()

  # we use setActive to indicate which type is active
  # this is to be used when something other than a topic is
  # activated. If the type has no specific element to activate,
  # everything is deactivated
  setActive: (type) ->
    @collection.unsetActive()
    @header.currentView.trigger 'activate', type

  unsetActive: ->
    @setActive()
