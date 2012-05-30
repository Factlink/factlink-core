//= require jquery.hoverIntent

window.ChannelView = Backbone.View.extend({
  tagName: "div",

  tmpl: Template.use("channels", "_channel"),

  initialize: function(opts) {
    var self = this;

    if (this.model !== undefined) {
      this.subchannels = new SubchannelList({channel: this.model});
      this.subchannels.fetch();

      this.factsView = new FactsView({
        collection: new ChannelFacts([],{
          channel: self.model
        }),
        channel: self.model
      });

      this.factsView.setLoading();

      this.factsView.collection.fetch({
        data: {
          timestamp: this.factsView._timestamp
        }
      });
    }
  },

  initSubChannels: function() {
    if ( this.$el.find('#contained-channel-list') ) {
      this.subchannelView = new SubchannelsView({
        collection: this.subchannels,
        el: this.$el.find('#contained-channel-list'),
        container: this.$el
      });
    }
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

  initSubChannelMenu: function() {
    if( this.model.get("followable?") ) {
      var addToChannelButton = this.$el.find("#add-to-channel");
      var followChannelMenu =this.$el.find("#follow-channel");

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

  remove: function() {
    Backbone.View.prototype.remove.apply(this);

    if ( this.factsView ) {
      this.factsView.close();
    }

    if ( this.addToChannelView ) {
      this.addToChannelView.close();
    }

    if ( this.subchannelView ) {
      this.subchannelView.close();
    }
  },

  render: function() {
    var self = this;

    if ( self.model ) {
      self.model.trigger('loading');

      this.$el
        .html( this.tmpl.render( this.model.toJSON() ) );

      this.initSubChannels();
      this.initSubChannelMenu();
      this.initAddToChannel();
      this.initMoreButton();

      this.$el.find('#facts_for_channel').append(this.factsView.render().el);

      // Set the active tab
      var tabs = this.$el.find('.tabs ul');
      tabs.find('li').removeClass('active');
      tabs.find('.factlinks').addClass('active');

      self.model.trigger('loaded')
                  .trigger('activate', self.model);
    }
    this.$el.find('header .authority')
      .tooltip({title: 'Authority of ' + self.model.attributes.created_by.username + ' on "' + self.model.attributes.title + '"'});


    return this;
  }
});

