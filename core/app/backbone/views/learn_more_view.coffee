class LearnMoreView extends Backbone.Marionette.ItemView
  template:
    text: """
        <a class="btn learn-more-btn-sign-in" href="{{global.path.sign_in_client}}">Sign in</a> or <a class="btn btn-primary learn-more-btn-learn-more" target="_blank" href="{{global.path.homepage}}">Learn more about Factlink</a> to sign up and join the discussion.
      """

class window.LearnMorePopupView extends Backbone.Marionette.ItemView
  className: 'learn-more learn-more-popup'

  template:
    text: """
        <a class="btn learn-more-btn-sign-in" href="{{global.path.sign_in_client}}">Sign in</a> or <a class="btn btn-primary learn-more-btn-learn-more" target="_blank" href="{{global.path.homepage}}">Learn more about Factlink</a> to sign up and join the discussion.
        <div class="bottom-arrow"></div>
      """

class window.LearnMoreBottomView extends LearnMoreView
  className: 'learn-more learn-more-bottom'
