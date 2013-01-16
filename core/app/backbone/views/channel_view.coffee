#= require jquery.hoverIntent

class window.ChannelViewLayout extends Backbone.Marionette.Layout
  tagName: 'div'
  template: 'channels/channel'
  regions:
    factList: '#facts_for_channel'
    activityList: '#activity_for_channel'
    addToChannelRegion: '.add-to-channel-region'

  templateHelpers: ->
    activities_link: ->
      @link + '/activities'

  initialize: (opts) ->
    @initSubChannels()
    @on 'render', =>
      @renderSubChannels()
      @$('header .authority').tooltip
        title: 'Authority of ' + @model.attributes.created_by.username + 'on "' + @model.attributes.title + '"'

      if @model.get('followable?')
        @addToChannelRegion.show new AddChannelToChannelsButtonView(model: @model)

  initSubChannels: ->
    if @model.get('inspectable?')
      @subchannelView = new SubchannelsView
        collection: @model.subchannels()
        model: @model

  renderSubChannels: ->
    if @subchannelView
      @subchannelView.render()
      @$('header .button-wrap').after @subchannelView.el

  onClose: ->
    @addToChannelView.close() if @addToChannelView
    @subchannelView.close() if @subchannelView

  activateTab: (selector) ->
    tabs = @$('.tabs ul')
    tabs.find('li').removeClass 'active'
    tabs.find(selector).addClass 'active'

class window.ChannelView extends ChannelViewLayout
  getFactsView: ->
    new FactsView
      collection: new ChannelFacts([], channel: @model)
      model: @model

  onRender: ->
    @factList.show @getFactsView()
    @activateTab '.factlinks'

class window.ChannelActivitiesView extends ChannelViewLayout
  events:
    "click .refresh_stream": "refresh"

  initialize: ->
    @bindTo @collection, 'change_count', @update_count, @
    @start_updating_count()
    @on 'attached', @start_updating_count, @
    @on 'detached', @stop_updating_count, @

  onClose: ->
    @stop_updating_count()

  stop_updating_count: ->
    console.info 'stop running', @running
    if @running
      clearTimeout(@timer)
      @running = false

  start_updating_count: ->
    console.info 'running', @running
    unless @running
      @running = true
      @timer = setTimeout((=> @fetch_activity_count(); @running=false; @start_updating_count()),10*1000)

  fetch_activity_count: ->
    @collection.fetch_count()

  update_count: ->
    this.$('.more .unread_count').html(@collection.get_new_activity_count());
    this.$('.more').toggle(@collection.get_new_activity_count() > 0);

  refresh: (e) ->
    @collection.fetch()
    e.preventDefault()
    e.stopPropagation()

  getActivitiesView: ->
    new ActivitiesView collection: @collection, disableEmptyView: @options.disableEmptyView

  onRender: ->
    @activityList.show @getActivitiesView()
    @activateTab '.activity'
