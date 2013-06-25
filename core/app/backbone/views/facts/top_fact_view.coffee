class window.TopFactView extends Backbone.Marionette.Layout
  className: 'top-fact'

  template: 'facts/top-fact'

  regions:
    wheelRegion: '.js-fact-wheel-region'
    userHeadingRegion: '.js-user-heading-region'

  onRender: ->
    @userHeadingRegion.show new UserInFactHeadingView
        model: new User @model.get 'created_by'
