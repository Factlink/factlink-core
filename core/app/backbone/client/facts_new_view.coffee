class window.FactsNewView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  template: "client/facts_new"

  className: 'fact-new-container'

  ui:
    'post_factlink': '.js-submit-post-factlink'

  events:
    'click .js-submit-post-factlink': 'post_factlink',

  regions:
    learnMoreRegion: '.js-learn-more-region'
    suggestedTopicsRegion: '.js-region-suggested-topics'
    shareNewFactRegion: '.js-region-share-new-fact'

  templateHelpers: ->
    fact_text: @options.fact_text
    add_to_topic_header: Factlink.Global.t.add_to_topics.capitalize()

  initialize: ->
    @addToCollection = new OwnChannelCollection

  onRender: ->
    @renderPersistentWheelView()

    if Factlink.Global.signed_in
      @renderAddToChannel()
      @renderSuggestedChannels()
      @renderShareNewFact()
      @openOpinionHelptext()
    else
      @learnMoreRegion.show new LearnMoreView

  onBeforeClose: ->
    @closeOpinionHelptext()

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
    @wheel = new FactVotes {}, fact: null
    persistentWheelView = new PersistentWheelView
      el: @$('.fact-wheel')
      model: @wheel
      showsTotalVotesTooltip: FactlinkApp.guided
    persistentWheelView.render()

    @wheel.on 'change:current_user_opinion', =>
      @closeOpinionHelptext()

  renderShareNewFact: ->
    @factSharingOptions = new FactSharingOptions
    @shareNewFactRegion.show new NewFactShareButtonsView
      model: @factSharingOptions

  post_factlink: (e)->
    @ui.post_factlink.prop('disabled', true).text('Posting...')

    channel_ids = @addToCollection.pluck('id')

    fact = new Fact
      opinion: @wheel.get('current_user_opinion')
      displaystring: @options.fact_text
      fact_url: @options.url
      fact_title: @options.title
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
    else
      @popoverAdd '.fact-wheel',
        side: 'top'
        popover_className: 'translucent-popover'
        contentView: new TextView text: "What's your opinion?"

  closeOpinionHelptext: ->
    @popoverRemove('.fact-wheel')

    if FactlinkApp.guided
      @openFinishHelptext()

  openFinishHelptext: ->
    unless @popoverOpened(".js-submit-post-factlink")?
      @popoverAdd '.js-submit-post-factlink',
        side: 'right'
        align: 'top'
        margin: 19
        container: @$('.js-finish-popover')
        contentView: new Backbone.Marionette.ItemView(template: 'tour/post_factlink')
