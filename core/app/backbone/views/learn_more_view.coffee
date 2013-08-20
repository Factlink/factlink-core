class window.LearnMorePopupView extends Backbone.Marionette.ItemView
  className: 'learn-more learn-more-popup'
  template: 'learn_more/content'

  templateHelpers:
    bottom_arrow: true

class window.LearnMoreBottomView extends Backbone.Marionette.ItemView
  className: 'learn-more learn-more-bottom'
  template: 'learn_more/content'

  templateHelpers:
    bottom_arrow: false
