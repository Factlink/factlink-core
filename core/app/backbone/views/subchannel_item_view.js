window.SubchannelItemView = Backbone.View.extend({
  tagName: "li",

  events: {
    "click" : "clickHandler",
    "click .close": "destroySubchannel"
  },

  destroySubchannel: function (e) {
    if ( confirm("Are you sure you want to remove this channel from your channel?") ) {
      this.model.destroy();
    }
    e.stopPropagation();
    return false;
  },

  tmpl: Template.use("subchannels", "_subchannel_item"),

  initialize: function() {
    this.model.bind('change', this.render, this);
    this.model.bind('destroy', this.remove, this);
    this.model.bind('remove', this.remove, this);
  },

  render: function() {
    this.$el
      .html( this.tmpl.render( this.model.toJSON() ))
      .attr('id', 'subchannel-' + this.model.id);
    return this;
  },

  clickHandler: function( e ) {
    if ( e.metaKey || e.ctrlKey || e.altKey ) return;

    var self = this;

    try {
      mpmetrics.track("Channel: Click on subchannel", {
        channel_id: currentChannel.id,
        subchannel_id: self.model.id
      });
    } catch(e) {}

    Router.navigate(this.model.user.get('username') + '/channels/' + this.model.id, true);

    e.preventDefault();

    return false;
  }
});
