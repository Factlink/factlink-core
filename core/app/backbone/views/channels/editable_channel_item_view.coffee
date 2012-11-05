class window.EditableChannelItemView extends Backbone.Marionette.ItemView
  tagName: "li"

  template: "channels/single_editable_menu_item"

  events:
    'click .delete': 'delete'

  initialize: -> @model.bind('change',@render,this)
  onRender:   -> @$el.attr('id', 'channel-' + @model.id)
  delete:     -> @model.destroy()
