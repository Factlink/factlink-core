class ShareButtonView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'share-button'
  template: 'generic/empty'

  events:
    'click': 'toggleChecked'

  modelEvents:
    'change': 'render'

  onRender: ->
    @$el.addClass "factlink-icon-#{@options.name}"
    @$el.toggleClass 'share-button-checked', @model.get(@options.name) || false

  toggleChecked: ->
    @model.set @options.name, !@model.get(@options.name)


class window.ShareNewFactView extends Backbone.Marionette.Layout
  className: 'share-new-fact'
  template: 'share/new_fact'

  regions:
    twitterRegion:  '.js-twitter-region'
    facebookRegion: '.js-facebook-region'

  onRender: ->
    @$el.toggle Factlink.Global.can_haz.share_new_factlink_buttons || false

    if currentUser.get('services').twitter
      @twitterRegion.show  new ShareButtonView(model: @model, name: 'twitter')

    if currentUser.get('services').facebook
      @facebookRegion.show new ShareButtonView(model: @model, name: 'facebook')
