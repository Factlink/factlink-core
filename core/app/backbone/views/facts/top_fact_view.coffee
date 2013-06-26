class window.TopFactView extends Backbone.Marionette.Layout
  className: 'top-fact'

  template: 'facts/top-fact'

  events:
    'click .js-repost': 'showRepost'

  regions:
    wheelRegion: '.js-fact-wheel-region'
    userHeadingRegion: '.js-user-heading-region'

  showRepost: ->
    FactlinkApp.Modal.show 'Repost Factlink',
      new AddToChannelModalView(model: @model)

  onRender: ->
    @userHeadingRegion.show new UserInFactHeadingView
        model: @model.user()
