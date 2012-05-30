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

  setTitle: function (title, options) {
    var fact_bubble = this.get('fact_bubble');

    fact_bubble['fact_title'] = title;

    return this.set('fact_bubble', fact_bubble, options);
  },

  getTitle: function() {
    return this.get('fact_bubble')['fact_title'];
  },

  removeFromChannel: function(channel, opts) {
    var self = this;
    opts.url = channel.url() + '/' + 'remove' + '/' + this.get('id') + '.json';
    var oldSuccess = opts.success;
    opts.success = function(){
      var indexOf = self.get('containing_channel_ids').indexOf(channel.id);
      if ( indexOf ) {
        self.get('containing_channel_ids').splice(indexOf, 1);
      }
      console.info('hoi');
      if (oldSuccess !== undefined) { console.info('hoi2');oldSuccess();}
    }
    $.ajax(_.extend({type: "post"}, opts));
  },

  addToChannel: function(channel, opts) {
    var self = this;
    opts.url = channel.url() + '/' + 'add' + '/' + this.get('id') + '.json';
    var oldSuccess = opts.success;
    opts.success = function(){
      self.get('containing_channel_ids').push(channel.id);
      if (oldSuccess !== undefined) { oldSuccess();}
    }
    $.ajax(_.extend({type: "post"}, opts));
  }

});
