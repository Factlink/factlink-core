(function() {

window.TitleView = Backbone.View.extend({

  initialize: function(opts) {
    this.model.on('change', this.render, this);
    this.collection.on('reset change', this.setChannelUnread, this);
  },

  render: function() {
    console.info("window.TitleView:render");
    document.title = (this.countString() + this.factlinkTitle());
  },

  factlinkTitle: function(){
    return "Factlink — Because the web needs what you know";
  },

  countString: function() {
    var count = this.model.totalUnreadCount();

    if (count > 0) {
      return "(" + count + ") ";
    } else {
      return "";
    }
  },

  setChannelUnread: function() {
    this.model.set('channelUnreadCount', this.collection.unreadCount());
  }
});

}());
