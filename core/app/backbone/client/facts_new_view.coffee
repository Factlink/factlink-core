class Tooltip
  constructor: ($) ->
    @$ = $
    @_shouldShowTooltip = true

  showTooltip: ->
    return if ( ! @_shouldShowTooltip )

    if FactlinkApp.guided
      @$('.js-opinion-animation').show();

    else
      @$('.fact-wheel').tooltip(
        title: "What's your opinion?",
        trigger: "manual"
      ).tooltip('show');

  close: ->
    @_shouldShowTooltip = false
    $(window).off 'resize.whatsyouropinion'
    @$('.fact-wheel').off 'click.whatsyouropinion'
    @$('.fact-wheel').tooltip('destroy')
    @$('.js-opinion-animation').hide()

  render: ->
    @$('.fact-wheel').on 'click.whatsyouropinion', =>
      @close()

    $(window).on 'resize.whatsyouropinion', => @showTooltip();

    @showTooltip()


class window.FactsNewView extends Backbone.Marionette.ItemView
  template: "client/facts_new"

  className: 'fact-new'

  events:
    'click #submit': 'post_factlink',
    'click .fact-wheel': 'closeWhatIsYourOpinionHelpText'

  templateHelpers: ->
    layout: @options.layout
    fact_text: @options.fact_text
    title: @options.title
    url: @options.url
    add_to_channel_header: Factlink.Global.t.add_to_channels.capitalize()
    csrf_token: @options.csrf_token
    guided: FactlinkApp.guided

  initialize: ->
    @addToCollection = new OwnChannelCollection
    @the_tooltip = new Tooltip($)

    @openWhatIsYourOpinionHelpText()

  onRender: ->
    @renderAddToChannel()
    @renderSuggestedChannels()
    @renderPersistentWheelView()
    @createCancelEvent()
    sometimeWhen(
      => @$el.is ":visible"
    , => @the_tooltip.render()
    )

  onBeforeClose: ->
    @the_tooltip.close()
    $('#submit').tooltip('destroy')

  renderAddToChannel: ->
    addToChannelView = new AutoCompleteChannelsView collection: @addToCollection
    addToChannelView.render()
    addToChannelView.on 'error', ->
      alert('Something went wrong when creating a new channel, sorry!')
    @$('#add-to-channels').html addToChannelView.el

  renderSuggestedChannels: ->
    if @options.url
      suggested_topics = new SuggestedSiteTopics([], site_url: @options.url)
      suggested_topics.fetch
        success: (collection) =>
          suggestionView = new FilteredSuggestedTopicsView
            collection: collection
            addToCollection: @addToCollection
          suggestionView.render()
          @$('#suggested-channels-region').html suggestionView.el

  renderPersistentWheelView: ->
    @wheel = new Wheel
    persistentWheelView = new PersistentWheelView
      el: @$('.fact-wheel'),
      model: @wheel
    persistentWheelView.render()

    persistentWheelView.on 'opinionSet', ->
      parent?.remote?.trigger('opinionSet')

  createCancelEvent: ->
    @$('#cancel').on 'click', (e)->
      mp_track("Modal: Cancel")
      e.preventDefault()
      # TODO when refactoring this view, move parent.remote code to clientcontroller
      parent.remote.hide()

  post_factlink: (e)->
    e.preventDefault()
    e.stopPropagation()

    channel_ids = @addToCollection.map (ch)-> ch.id

    fact = new Fact
      opinion: @wheel.userOpinion()
      displaystring:  @$('textarea#fact').val()
      fact_url: @$('input#url').val()
      fact_title: @$('input#title').val()
      channels: channel_ids

    fact.save {},
      success: =>
        fact.set containing_channel_ids: channel_ids
        @trigger 'factCreated', fact

  openWhatIsYourOpinionHelpText: ->
    if FactlinkApp.guided
      @tooltipAdd '.fact-wheel',
        "What's your opinion?",
        "Here I can tell you something about colors and opinions. Only not in HTML yet.",
        { side: 'left' }

  closeWhatIsYourOpinionHelpText: ->
    if FactlinkApp.guided
      @tooltipRemove('.fact-wheel')
      @openClickHereToFinishHelpText()

  openClickHereToFinishHelpText: ->
    @tooltipAdd '#submit',
      "Great!",
      "Click here to finish.",
      { side: 'bottom' }

_.extend window.FactsNewView.prototype, Backbone.Factlink.TooltipMixin
