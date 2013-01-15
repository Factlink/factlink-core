createWhatsYourOpinionTooltip = ->
  showTooltip = ->
    return if ( ! _shouldShowTooltip )

    $('.fact-wheel').tooltip(
      title: "What's your opinion?",
      trigger: "manual"
    ).tooltip('show');

  destroyTooltip = ->
    $('.fact-wheel').tooltip('destroy')

  hideOpinionAnimation = ->
    $('.js-opinion-animation').hide();

  hideTooltip = ->
    _shouldShowTooltip = false

    destroyTooltip();

  _shouldShowTooltip = true

  $('.fact-wheel').on 'click', ->
    hideTooltip()
    hideOpinionAnimation()

    if FactlinkApp.guided
      $('#submit').tooltip(
        title: "Great! Click here to finish",
        trigger: "manual"
      ).tooltip("show");

  $(window).on 'resize', ->
    showTooltip();

  showTooltip()


class window.FactsNewView extends Backbone.Marionette.ItemView
  template: "client/facts_new"

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

  onRender: ->
    @renderAddToChannel()
    @renderSuggestedChannels()
    @renderPersistentWheelView()
    @createCancelEvent()
    sometimeWhen(
      => @$el.is ":visible"
    , => createWhatsYourOpinionTooltip();
    )


  renderAddToChannel: ->
    addToChannelView = new AutoCompleteChannelsView collection: @addToCollection
    addToChannelView.render()
    addToChannelView.on 'error', ->
      alert('Something went wrong when creating a new channel, sorry!')
    @$('#add-to-channels').html addToChannelView.el

  renderSuggestedChannels: ->
    if @options.url
      suggestionView = new FilteredSuggestedSiteTopicsView
        addToCollection: @addToCollection
        site_url: @options.url
      suggestionView.render()
      @$('#suggested-channels-region').html suggestionView.el

  renderPersistentWheelView: ->
    persistentWheelView = new PersistentWheelView
      el: @$('.fact-wheel'),
      model: new Wheel()
    persistentWheelView.render()

    persistentWheelView.on 'opinionSet', ->
      parent?.remote?.trigger('opinionSet')

  createCancelEvent: ->
    @$('#cancel').on 'click', (e)->
      mp_track("Modal: Cancel")
      e.preventDefault()
      # TODO when refactoring this view, move parent.remote code to clientcontroller
      parent.remote.hide()

