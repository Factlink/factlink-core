class window.ShareNewFactView extends Backbone.Marionette.ItemView
  template:
    text: """
      Some buttons.
    """

  onRender: ->
    @$el.toggle Factlink.Global.can_haz.share_new_factlink_buttons || false
