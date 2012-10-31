//= require jquery.hoverIntent

window.ChannelViewLayout = Backbone.Marionette.Layout.extend({
  tagName: "div",

  template: 'channels/_channel',

  regions: {
    factList: '#facts_for_channel',
    activityList: '#activity_for_channel'
  },

  initialize: function(opts) {
    this.initSubChannels();
    this.on('render', _.bind(function(){
      this.renderSubChannels();
      this.initSubChannelMenu();
      this.initAddToChannel();
      this.$('header .authority').tooltip({title: 'Authority of ' + this.model.attributes.created_by.username + ' on "' + this.model.attributes.title + '"'});
    },this));
  },

  initSubChannels: function() {
    if (this.model.get('inspectable?')){
      this.subchannelView = new SubchannelsView({
        collection: this.model.subchannels(),
        model: this.model
      });
    }
  },

  renderSubChannels: function(){
    if (this.subchannelView) {
      this.subchannelView.render();
      this.$('header .button-wrap').after(this.subchannelView.el);
    }
  },

  initSubChannelMenu: function() {
    if( this.model.get("followable?") ) {
      var addToChannelButton = this.$("#add-to-channel");
      var followChannelMenu =this.$("#follow-channel");

      followChannelMenu.css({"left": addToChannelButton.position().left});

      addToChannelButton.hoverIntent(
        function() { followChannelMenu.fadeIn("fast"); },
        function() { followChannelMenu.delay(600).fadeOut("fast"); }
      );

      followChannelMenu.on("mouseover", function() {
        followChannelMenu.stop(true, true).show();
      });

      followChannelMenu.on("mouseout", function() {
       if (!followChannelMenu.find("input#channel_title").is(":focus")) {
          followChannelMenu.delay(500).fadeOut("fast");
        }
      });
    }
  },

  initAddToChannel: function() {
    if ( this.$('#add-to-channel') && typeof currentUser !== "undefined" && typeof currentChannel !== "undefined" ) {
      this.addToChannelView = new AddToChannelView({
        collection: currentUser.channels,
        el: this.$('#follow-channel'),
        model: currentChannel,
        containingChannels: currentChannel.getOwnContainingChannels()
      }).render();
    }
  },
  onClose: function() {
    if ( this.addToChannelView ) {
      this.addToChannelView.close();
    }

    if ( this.subchannelView ) {
      this.subchannelView.close();
    }
  },
  activateTab: function(selector) {
    var tabs = this.$('.tabs ul');
    tabs.find('li').removeClass('active');
    tabs.find(selector).addClass('active');
  }

});

window.ChannelView = ChannelViewLayout.extend({

  getFactsView: function() {
    return new FactsView({
      collection: new ChannelFacts([],{
        channel: this.model
      }),
      model: this.model
    });

  },

  onRender: function() {
    this.factList.show(this.getFactsView());
    this.activateTab(".factlinks");
  }
});


window.ChannelActivitiesView = ChannelViewLayout.extend({

  getActivitiesView: function(){
    return new ActivitiesView({collection: this.collection});
  },

  onRender: function() {
    this.activityList.show(this.getActivitiesView());
    this.activateTab('.activity');
  }

});
