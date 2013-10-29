class PreviewShareFactView extends Backbone.Marionette.Layout
  className: 'preview-share-fact'

  template:
    text: """
      <div><strong>Share to social networks:</strong></div>

      <div class="preview-share-fact-link-container">
        <a target="_blank" href="#">&ldquo;{{displaystring}}&rdquo;</a>
      </div>

      <div class="pull-right">
        <span class="js-share-buttons-region"></span>
        <button class="button button-confirm" data-disable-with="Sharing...">Share</button>
      </div>
    """

  regions:
    shareButtonsRegion: '.js-share-buttons-region'

  onRender: ->
    @shareButtonsRegion.show new ShareButtonsView
      model: @options.factSharingOptions

class window.TopFactShareButtonsView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  className: 'top-fact-share-buttons'
  template: 'facts/top_fact_share_buttons'

  events:
    'click .js-start-conversation': '_toggleStartConversation'
    'click .js-twitter': '_toggleTwitter'
    'click .js-facebook': '_toggleFacebook'

  templateHelpers: ->
    current_user: currentUser.toJSON()

  _toggleStartConversation: ->
    @_togglePopover '.js-start-conversation', =>
      mp_track 'Factlink: Open conversation popover'

      new StartConversationView(model: @model)

  _toggleTwitter: ->
    @_togglePopover '.js-social-share', =>
      mp_track 'Factlink: Open social share popover (twitter)'

      factSharingOptions = new FactSharingOptions twitter: true
      new PreviewShareFactView factSharingOptions: factSharingOptions, model: @model

  _toggleFacebook: ->
    @_togglePopover '.js-social-share', =>
      mp_track 'Factlink: Open social share popover (facebook)'

      factSharingOptions = new FactSharingOptions facebook: true
      new PreviewShareFactView factSharingOptions: factSharingOptions, model: @model

  _togglePopover: (selector, contentViewConstructor) ->
    if @popoverExists selector
      @popoverRemove selector
    else
      view = contentViewConstructor()

      @popoverAdd selector,
        side: 'bottom'
        align: 'center'
        fadeTime: 100
        contentView: view

      @listenTo view, 'sent_message', -> @popoverRemove '.js-share'
