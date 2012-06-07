window.ChannelItemView = Backbone.View.extend({
  tagName: "li",

  tmpl: Template.use("channels", "_single_menu_item"),

  initialize: function() {
    this.addClassToggle('active');

    this.model.bind('change', this.render, this);
    this.model.bind('destroy', this.remove, this);
    this.model.bind('remove', this.remove, this);
    this.model.bind('activate', this.activeOn, this);
    this.model.bind('deactivate', this.activeOff, this);

    // The model can already be set active before the view has rendered
    if ( this.model.isActive ) {
      this.activeOn();
    }
  },

  render: function() {
    this.$el
      .html( this.tmpl.render(this.model.toJSON()) )
      .attr('id', 'channel-' + this.model.id);

    return this;
  },

  remove: function() {
    this.$el.remove();
  }


});
