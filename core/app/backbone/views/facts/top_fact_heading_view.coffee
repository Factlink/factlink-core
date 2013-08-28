class window.TopFactHeadingLinkView extends Backbone.Marionette.ItemView
  className: 'top-fact-heading'
  template: 'facts/top_fact_heading_link'

  ui: favicon: '.js-favicon'

  verifyLoaded:  =>
    @ui.favicon.removeClass('favicon-missing') if @ui.favicon[0].naturalWidth
    return

  onRender: ->
    @ui.favicon.on 'load', @verifyLoaded
    @verifyLoaded()
    return

class window.TopFactHeadingUserView extends Backbone.Marionette.ItemView
  className: 'top-fact-heading'
  template: 'facts/top_fact_heading_user'
