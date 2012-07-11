//= require jquery.hoverIntent
//= require ./channel_view

window.ChannelActivitiesView = ChannelViewLayout.extend({
  tagName: "div",

  template: "channels/_channel",

  initialize: function(opts) {
    this.activitiesView = new ActivitiesView({
      el: '#activity_for_channel',
      collection: new ChannelActivities([],{
        channel: this.model
      })
    });
    this.activitiesView.collection.loadMore();
    this.initSubChannels()
  },

  initAddToChannel: function() {
    if ( this.$el.find('#add-to-channel') && typeof currentUser !== "undefined" ) {
      this.addToChannelView = new AddToChannelView({
        collection: currentUser.channels,
        el: this.$el.find('#follow-channel'),
        model: currentChannel,
        containingChannels: currentChannel.getOwnContainingChannels()
      }).render();
    }
  },

  initMoreButton: function() {
    var containedChannels = this.$el.find('#contained-channels');
    if  ( containedChannels ) {
      this.$el.find('#more-button').bind('click', function() {
        var button = $(this).find(".label");
        containedChannels.find('.overflow').slideToggle(function(e) {
          button.text($(button).text() === 'more' ? 'less' : 'more');
        });
      });
    }
  },

  onClose: function() {
    if ( this.activitiesView ) {
      this.activitiesView.close();
    }

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
    this.initMoreButton();

    this.activitiesView.$el = this.$('#activity_for_channel');
    this.activitiesView.render();

    // Set the active tab
    var tabs = this.$('.tabs ul');
    tabs.find('li').removeClass('active');
    tabs.find('.activity').addClass('active');

    this.model.trigger('loaded')
                .trigger('activate', this.model);
  }
});