class window.EditableChannelItemView extends Backbone.Marionette.ItemView
  tagName: "li"

  template: "channels/_single_editable_menu_item"

  initialize: () ->
    @model.bind('change',@render,this)

  onRender: () ->
    @$el.attr('id', 'channel-' + @model.id)

_.extend ChannelItemView.prototype, ToggleMixin