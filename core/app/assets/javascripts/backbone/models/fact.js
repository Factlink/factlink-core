window.Fact = Backbone.Model.extend({
  getOwnContainingChannels: function() {
    var containingChannels = this.get('containing_channel_ids');
    var ret = [];

    currentUser.channels.each(function(ch) {
      if ( _.indexOf(containingChannels, ch.id ) !== -1 ) {
        ret.push(ch);
      }
    });

    return ret;
  },

  url: function() {
    return '/facts/' + this.get('id');
  },

  removeFromChannel: function (opts) {
    var self = this;

    $.ajax({
      url: Backbone.Model.prototype.url.apply(this, arguments),
      type: "DELETE",
      success: function () {
        self.collection.remove(self);
    
        opts.success.apply(this, arguments);
      },
      error: opts.error
    });
  }
});
