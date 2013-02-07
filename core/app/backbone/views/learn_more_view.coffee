class LearnMoreView extends Backbone.Marionette.ItemView
  template:
    text: """
        <a class="btn learn-more-btn-sign-in">Sign in</a> or <a class="btn btn-primary learn-more-btn-learn-more">Learn more about Factlink</a> to sign up and join the discussion.
      """

class window.LearnMorePopupView extends LearnMoreView
  className: 'learn-more learn-more-popup'

class window.LearnMoreBottomView extends LearnMoreView
  className: 'learn-more learn-more-bottom'
