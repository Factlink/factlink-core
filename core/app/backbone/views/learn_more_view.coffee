class LearnMoreView extends Backbone.Marionette.ItemView
  template: 'learn_more/learn_more'

class window.LearnMorePopupView extends LearnMoreView
  className: 'learn-more modal-box learn-more-popup'

class window.LearnMoreBottomView extends LearnMoreView
  className: 'learn-more learn-more-bottom'
