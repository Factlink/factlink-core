class window.TopFactHeadingLinkView extends Backbone.Marionette.ItemView
  className: 'top-fact-heading'
  template: 'facts/top_fact_heading_link'

  ui: favicon: '.js-favicon'

  verifyLoaded: ->
    @ui.favicon.removeClass('favicon-missing') if @ui.favicon[0].naturalWidth

  onRender: ->
    @ui.favicon.on 'load', (=> @verifyLoaded(); return)
    @verifyLoaded()

class window.TopFactHeadingUserView extends Backbone.Marionette.ItemView
  className: 'top-fact-heading'
  template: 'facts/top_fact_heading_user'

  onRender: ->
    UserPopoverContentView.makeTooltip @, @model
