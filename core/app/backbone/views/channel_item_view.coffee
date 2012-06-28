window.ChannelItemView = Backbone.Marionette.ItemView.extend
  tagName: "li"

  template: "channels/_single_menu_item"

  initialize: () ->
    this.addClassToggle('active')

    this.model.bind('activate', this.activeOn, this)
    this.model.bind('deactivate', this.activeOff, this)

  onRender: () ->
    this.$el.attr('id', 'channel-' + this.model.id)
    this.activeOn() if this.model.isActive

_.extend ChannelItemView.prototype, ToggleMixin