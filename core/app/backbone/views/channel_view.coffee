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
  getActivitiesView: ->
    new ActivitiesView collection: @collection

  onRender: ->
    @activityList.show @getActivitiesView()
    @activateTab '.activity'
