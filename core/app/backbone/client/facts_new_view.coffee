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
    'click .fact-wheel': 'closeOpinionHelptext'

  templateHelpers: ->
    layout: @options.layout
    fact_text: @options.fact_text
    title: @options.title
    url: @options.url
    optional: Factlink.Global.t.optional
    add_to_topic_header: Factlink.Global.t.add_to_topics.capitalize()
    csrf_token: @options.csrf_token
    guided: FactlinkApp.guided

  initialize: ->
    @addToCollection = new OwnChannelCollection
    @the_tooltip = new Tooltip($)

    @openOpinionHelptext()

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
      alert("Something went wrong when creating a new #{Factlink.Global.t.topic}")
    @$('#add-to-channels').html addToChannelView.el

  renderSuggestedChannels: ->
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

  openOpinionHelptext: ->
    if FactlinkApp.guided
      view = new TooltipView(template: 'tooltips/give_your_opinion')
      @tooltipAdd '.fact-wheel',
        "What's your opinion?",
        "",
        { side: 'left', align: 'top', margin: 20, contentView: view }

  closeOpinionHelptext: ->
    if FactlinkApp.guided
      @tooltipRemove('.fact-wheel')
      @openFinishHelptext()

  openFinishHelptext: ->
    unless @tooltip("#submit")?
      @tooltipAdd '#submit',
        "You're ready to post this!",
        "You can add this Factlink to a " + Factlink.Global.t.topic + " so you can find it more easily later, or post this immediately.",
        { side: 'right', align: 'top', margin: 19, container: @$('.js-finish-popover') }

_.extend window.FactsNewView.prototype, Backbone.Factlink.TooltipMixin
