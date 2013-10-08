class Tooltip
  constructor: ($) ->
    @$ = $
    @_shouldShowTooltip = true

  showTooltip: ->
    return if ( ! @_shouldShowTooltip )

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

  render: ->
    $(window).on 'resize.whatsyouropinion', => @showTooltip();

    @showTooltip()


class window.FactsNewView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  template: "client/facts_new"

  className: 'fact-new'

  ui:
    'post_factlink': '.js-submit-post-factlink'
    'opinion_animation': '.js-opinion-animation'

  events:
    'click .js-submit-post-factlink': 'post_factlink',
    'click .fact-wheel': 'closeOpinionHelptext'

  regions:
    suggestedTopicsRegion: '.js-region-suggested-topics'
    shareNewFactRegion: '.js-region-share-new-fact'

  templateHelpers: ->
    layout: @options.layout
    fact_text: @options.fact_text
    title: @options.title
    url: @options.url
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
    @renderShareNewFact()
    sometimeWhen(
      => @$el.is ":visible"
    , => @renderHints()
    )

  onBeforeClose: ->
    @closeHints()
    @ui.post_factlink.tooltip('destroy')

  renderAddToChannel: ->
    addToChannelView = new AutoCompleteChannelsView collection: @addToCollection
    addToChannelView.render()
    addToChannelView.on 'error', ->
      FactlinkApp.NotificationCenter.error "Something went wrong when creating a new #{Factlink.Global.t.topic}"
    @$('.js-add-to-channels').html addToChannelView.el

  renderSuggestedChannels: ->
    suggested_topics = new SuggestedSiteTopics([], site_url: @options.url)
    suggested_topics.fetch()

    suggestionView = new FilteredSuggestedTopicsView
      collection: suggested_topics
      addToCollection: @addToCollection
    @suggestedTopicsRegion.show suggestionView

  renderPersistentWheelView: ->
    @wheel = new Wheel
    persistentWheelView = new PersistentWheelView
      el: @$('.fact-wheel'),
      model: @wheel
    persistentWheelView.render()

    persistentWheelView.on 'opinionSet', =>
      @closeHints()
      parent?.remote?.trigger('opinionSet')

  renderHints: ->
    @the_tooltip.render()

    if FactlinkApp.guided
      @ui.opinion_animation.show();

  closeHints: ->
    @the_tooltip.close()

    @ui.opinion_animation.hide()

  renderShareNewFact: ->
    @factSharingOptions = new FactSharingOptions

    shareNewFactView = new ShareNewFactView model: @factSharingOptions
    @shareNewFactRegion.show shareNewFactView

  post_factlink: (e)->
    e.preventDefault()
    e.stopPropagation()
    disableInputWithDisableWith(@ui.post_factlink)

    channel_ids = @addToCollection.map (ch)-> ch.id

    fact = new Fact
      opinion: @wheel.userOpinionWithS()
      displaystring:  @$('textarea.js-fact').val()
      fact_url: @$('input.js-url').val()
      fact_title: @$('input.js-title').val()
      channels: channel_ids
      fact_sharing_options: @factSharingOptions.toJSON()

    fact.save {},
      success: =>
        fact.set containing_channel_ids: channel_ids
        @trigger 'factCreated', fact

  openOpinionHelptext: ->
    if FactlinkApp.guided
      @popoverAdd '.fact-wheel',
        side: 'left'
        align: 'top'
        margin: 20
        popover_className: 'fact-new-opinion-popover factlink-popover'
        contentView: new Backbone.Marionette.ItemView(template: 'tour/give_your_opinion')

  closeOpinionHelptext: ->
    if FactlinkApp.guided
      @popoverRemove('.fact-wheel')
      @openFinishHelptext()

  openFinishHelptext: ->
    unless @popoverOpened(".js-submit-post-factlink")?
      @popoverAdd '.js-submit-post-factlink',
        side: 'right'
        align: 'top'
        margin: 19
        container: @$('.js-finish-popover')
        contentView: new Backbone.Marionette.ItemView(template: 'tour/post_factlink')
