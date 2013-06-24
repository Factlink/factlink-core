class ShareButtonView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'share-button'
  template:
    text: ''

  events:
    'click': 'onClick'

  modelEvents:
    'change': 'render'

  onRender: ->
    @$el.addClass "factlink-icon-#{@options.name}"
    @$el.toggleClass 'share-button-checked', @model.get(@options.name)

  onClick: ->
    @model.set @options.name, !@model.get(@options.name)


class window.ShareNewFactView extends Backbone.Marionette.Layout
  className: 'share-new-fact'
  template:
    text: """
      <span class="js-twitter-region"></span>
      <span class="js-facebook-region"></span>
    """

  regions:
    twitterRegion:  '.js-twitter-region'
    facebookRegion: '.js-facebook-region'

  initialize: ->
    @model = new Backbone.Model twitter: false, facebook: false

  onRender: ->
    @$el.toggle Factlink.Global.can_haz.share_new_factlink_buttons || false

    @twitterRegion.show  new ShareButtonView(model: @model, name: 'twitter')
    @facebookRegion.show new ShareButtonView(model: @model, name: 'facebook')
