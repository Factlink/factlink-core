//= require jquery.hoverIntent

//TODO fix duplication with channel_view

window.ChannelActivitiesView = Backbone.View.extend({
  tagName: "div",

  initialize: function(opts) {
    this.useTemplate("channels", "_channel");
    var self = this;

    if (this.model !== undefined) {
      this.subchannels = new SubchannelList({channel: this.model});
      this.subchannels.fetch();

      this.activitiesView = new ActivitiesView({
        collection: new ChannelActivities([],{
          channel: self.model
        })
      });
      this.activitiesView.collection.fetch();
    }
  },

  reInit: function(opts) {
    if (!this.model || this.model.id !== opts.model.id){
      this.close();
      return new ChannelActivitiesView(opts);
    }
    return this;
  },


  initSubChannels: function() {
    if ( $( this.el ).find('#contained-channel-list') ) {
      this.subchannelView = new SubchannelsView({
        collection: this.subchannels,
        el: $( this.el ).find('#contained-channel-list'),
        container: $( this.el )
      });
    }
  },

  initAddToChannel: function() {
    if ( $( this.el ).find('#add_to_channel') && typeof currentUser !== "undefined" ) {
      this.addToChannelView = new AddToChannelView({
        collection: currentUser.channels,
        el: $( this.el ).find('#follow-channel'),
        model: currentChannel,
        containingChannels: currentChannel.getOwnContainingChannels()
      }).render();
    }
  },

  initMoreButton: function() {
    var containedChannels = $( this.el ).find('#contained-channels');
    if  ( containedChannels ) {
      $( this.el ).find('#more-button').bind('click', function() {
        var button = $(this).find(".label");
        containedChannels.find('.overflow').slideToggle(function(e) {
          button.text($(button).text() === 'more' ? 'less' : 'more');
        });
      });
    }
  },

  initSubChannelMenu: function() {
    if( this.model.get("followable?") ) {
      var addToChannelButton = $( this.el ).find("#add_to_channel");
      var followChannelMenu =$( this.el ).find("#follow-channel");

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

  render: function() {
    var self = this;

    if ( self.model ) {
      self.model.trigger('loading');

      $( this.el )
        .html( Mustache.to_html(this.tmpl, this.model.toJSON() ));

      this.initSubChannels();
      this.initSubChannelMenu();
      this.initAddToChannel();
      this.initMoreButton();

      $( this.el ).find('#facts_for_channel').append(this.activitiesView.render().el);

      self.model.trigger('loaded')
                  .trigger('activate', self.model);
    }

    return this;
  }
});

