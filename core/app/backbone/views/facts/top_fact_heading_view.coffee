class window.TopFactHeadingLinkView extends Backbone.Marionette.ItemView
  className: 'top-fact-heading'
  template: 'facts/top_fact_heading_link'

  verifyLoaded = (jqImgEl) ->
    jqImgEl.removeClass('favicon-missing') if jqImgEl[0].naturalWidth
    return

  onRender: ->
    img =  @$('.favicon-missing').first()
    img.on 'load', -> verifyLoaded img
    verifyLoaded img
    return

class window.TopFactHeadingUserView extends Backbone.Marionette.ItemView
  className: 'top-fact-heading'
  template: 'facts/top_fact_heading_user'
