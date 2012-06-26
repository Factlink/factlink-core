window.SubchannelItemView = Backbone.Factlink.PlainView.extend({
  tagName: "li",

  events: {
    "click" : "clickHandler",
    "click .close": "destroySubchannel"
  },

  template: "subchannels/_subchannel_item",

  initialize: function() {
    this.model.bind('change', this.render, this);
    this.model.bind('destroy', this.remove, this);
    this.model.bind('remove', this.remove, this);
  },

  onRender: function() {
    this.$el.attr('id', 'subchannel-' + this.model.id);
  },

  destroySubchannel: function (e) {
    if ( confirm("Are you sure you want to remove this channel from your channel?") ) {
      this.model.destroy();
    }
    e.stopPropagation();
    return false;
  },

  clickHandler: function( e ) {
    if ( e.metaKey || e.ctrlKey || e.altKey ) return;

    var self = this;

    mp_track("Channel: Click on subchannel", {
      channel_id: currentChannel.id,
      subchannel_id: self.model.id
    });

    Backbone.history.navigate(this.model.user.get('username') + '/channels/' + this.model.id, true);

    e.preventDefault();

    return false;
  }
});