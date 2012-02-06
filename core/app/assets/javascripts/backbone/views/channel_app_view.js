window.AppView = Backbone.View.extend({
  el: $('#container'),

  initialize: function(options) {
    if (typeof(options)==='undefined') {options = {};}

    this.channelCollectionView = new ChannelCollectionView({
      collection: Channels
    });

    this.channelView = new ChannelView();
    this.views = [new RelatedUsersView()];

    this.setupChannelReloading();

    this.userView = new UserView({
      model: ( typeof currentChannel !== "undefined" ) ? currentChannel.user : currentUser
    });
  },

  // TODO: This function needs to wait for loading (Of channel contents in main column)
  setupChannelReloading: function(){
    var args = arguments;
    setTimeout(function(){
      Channels.fetch({
        success: args.callee
      });
    }, 7000);
  },

  reInit: function(opts) {
    var channel = opts.model;
    var oldChannel = currentChannel;

    window.currentChannel = channel;

    if ( channel.user.id !== oldChannel.user.id ) {
      this.channelCollectionView.reload(currentChannel.id);
    }

    for(var i = 0; i < this.views.length; i++){
      this.views[i] = this.views[i].reInit({model: channel});
    }
    this.userView = this.userView.reInit({model:channel.user, content_type: opts.content_type});
    this.setChannelViewFor(opts);

    return this;
  },

  setChannelViewFor : function(options) {
    if ((options.content_type === this.options.content_type) || (options.model === undefined )) {
      this.channelView = this.channelView.reInit(options);
    } else {
      this.channelView.close();
      if (options.content_type === 'activities'){
        this.channelView = new ChannelActivitiesView(options);
      } else {
        this.channelView = new ChannelView(options);
      }

    }
  },

  render: function() {
    for(var i = 0; i < this.views.length; i++){
      this.views[i].render();
    }
    this.channelView.render();
    this.userView.render();
    $('#main-wrapper').html( this.channelView.el );
  }

});
