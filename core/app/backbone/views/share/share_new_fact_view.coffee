class window.ShareNewFactView extends Backbone.Marionette.ItemView
  className: 'share-new-fact'
  template:
    text: """
      <span class="factlink-icon-twitter share-new-fact-button"></span>
      <span class="factlink-icon-facebook share-new-fact-button"></span>
    """

  onRender: ->
    @$el.toggle Factlink.Global.can_haz.share_new_factlink_buttons || false
