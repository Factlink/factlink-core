window.SubchannelItemView = Backbone.View.extend({
  tagName: "li",

  events: {
    "click" : "clickHandler"
  },

  initialize: function() {
    this.useTemplate("subchannels", "_subchannel_item");

    this.model.bind('change', this.render, this);
    this.model.bind('destroy', this.remove, this);
    this.model.bind('remove', this.remove, this);
  },

  render: function() {
    this.$( this.el )
      .html( Mustache.to_html(this.tmpl, this.model.toJSON() ))
      .attr('id', 'subchannel-' + this.model.id);
    return this;
  },

  clickHandler: function( e ) {
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
