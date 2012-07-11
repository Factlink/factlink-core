//= require jquery.hoverIntent


// dirty way of factoring out copypasted code, but we should not have those mega-controller views
// refactor correctly if this object annoys you ;)
window.ChannelViewLayout = Backbone.Marionette.Layout.extend({
  tagName: "div",

  template: 'channels/_channel',

  regions: {
    factList: '#facts_for_channel',
    activityList: '#activity_for_channel'
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
    if ( this.$('#add-to-channel') && typeof currentUser !== "undefined" ) {
      this.addToChannelView = new AddToChannelView({
        collection: currentUser.channels,
        el: this.$('#follow-channel'),
        model: currentChannel,
        containingChannels: currentChannel.getOwnContainingChannels()
      }).render();
    }
  },

});

window.ChannelView = ChannelViewLayout.extend({

  initialize: function(opts) {
    this.initSubChannels();
  },

  getFactsView: function() {
    return new FactsView({
      collection: new ChannelFacts([],{
        channel: this.model
      }),
      model: this.model
    });

  },

  onClose: function() {
    if ( this.addToChannelView ) {
      this.addToChannelView.close();
    }

    if ( this.subchannelView ) {
      this.subchannelView.close();
    }
  },

  onRender: function() {
    this.model.trigger('loading');

    this.renderSubChannels();
    this.initSubChannelMenu();
    this.initAddToChannel();

    this.factList.show(this.getFactsView())

    // Set the active tab
    var tabs = this.$('.tabs ul');
    tabs.find('li').removeClass('active');
    tabs.find('.factlinks').addClass('active');

    this.model.trigger('loaded')
                .trigger('activate', this.model);

    this.$el.find('header .authority')
      .tooltip({title: 'Authority of ' + this.model.attributes.created_by.username + ' on "' + this.model.attributes.title + '"'});
  }
});