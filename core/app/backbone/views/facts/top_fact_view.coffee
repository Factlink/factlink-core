class window.TopFactView extends Backbone.Marionette.Layout
  className: 'top-fact'

  template: 'facts/top-fact'

  events:
    'click .js-repost': 'showRepost'

  regions:
    wheelRegion: '.js-fact-wheel-region'

  showRepost: ->
    FactlinkApp.Modal.show 'Repost Factlink',
      new AddToChannelModalView(model: @model)

    mp_track "Factlink: Open repost modal"
