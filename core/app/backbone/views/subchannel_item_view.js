window.SubchannelItemView = Backbone.Marionette.ItemView.extend({
  tagName: "li",

  events: {
    "click" : "clickHandler",
    "click .close": "destroySubchannel"
  },

  template: "subchannels/_subchannel_item",

  initialize: function() {
    this.model.bind('destroy', this.close, this);
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

  //TODO do this without this amount of effort, this code is duplicated from default click handler
  clickHandler: function( e ) {
    if ( e.metaKey || e.ctrlKey || e.altKey ) return;

    mp_track("Channel: Click on subchannel", {
      channel_id: currentChannel.id,
      subchannel_id: this.model.id
    });

    Backbone.history.navigate(this.model.get('created_by').username + '/channels/' + this.model.id, true);

    e.preventDefault();

    return false;
  }
});