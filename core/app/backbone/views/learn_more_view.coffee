# TODO: move to own view
class window.LearnMoreView extends Backbone.Marionette.ItemView
  template:
    text: """
        <a class="btn">Sign in</a> or <a class="btn btn-primary">Learn more about Factlink</a> to sign up and join the discussion.
      """

class window.LearnMorePopupView extends LearnMoreView
  className: 'learn-more-popup'
