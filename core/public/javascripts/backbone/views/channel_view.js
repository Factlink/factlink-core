window.ChannelView = Backbone.View.extend({

  el: $("#main-wrapper"),
  tmpl: $('#channel_overview').html(),
  
  initialize: function(opts) {
    var self = this;
    
    this.subchannels = new SubchannelList({channel: this.model});
    this.subchannels.fetch();
  },
  
  initSubChannels: function() {
    if ( this.el.find('#contained-channel-list') ) {
      this.subchannelView = new SubchannelsView({
        collection: this.subchannels,
        el: this.el.find('#contained-channel-list')
      });
    }
  },
  
  initAddToFact: function() {
    if ( this.el.find('#add_to_channel') && typeof currentUser !== "undefined" ) {
      this.ownChannelView = new OwnChannelCollectionView({
        collection: currentUser.channels,
        el: this.el.find('#follow-channel')
      }).render();
    }
  },

  initMoreButton: function() { 
    var containedChannels = this.el.find('#contained-channels');
    if  ( containedChannels ) {
    this.el.find('.more-button').bind('click', function() { 
        var button = $(this).find(".label");
        containedChannels.slideToggle(function(e) { 
          button.text($(button).text() === 'more' ? 'less' : 'more');
        });
      });
    }
  },

  initSubChannelMenu: function() { 
    if( this.model.get("followable?") ) { 
      var addToChannelButton = this.el.find("#add_to_channel");
      var followChannelMenu = this.el.find("#follow-channel");
      followChannelMenu.css({"left": addToChannelButton.position().left});
      addToChannelButton.hoverIntent(
        function() { followChannelMenu.fadeIn("fast"); }, 
        function() { followChannelMenu.delay(600).fadeOut("fast"); }
      );
      followChannelMenu.on("mouseover", function() { 
        followChannelMenu.stop(true, true).css({"opacity": "1"});
      });
      followChannelMenu.on("mouseout", function() { 
       if (!followChannelMenu.find("input#channel_title").is(":focus")) {
          followChannelMenu.delay(500).fadeOut("fast");
        }
      });
    }
  },

  render: function() { 
    var self = this;

    if ( self.model ) {
      self.model.trigger('loading');
      
      this.el
        .html( $.mustache(this.tmpl, this.model.toJSON() ));
      
      this.initSubChannels();
      this.initSubChannelMenu();
      this.initAddToFact();
      this.initMoreButton(); 
        
      self.model.trigger('loaded')
                  .trigger('activate', self.model);
                  
      $.ajax({
        url: self.model.url() + '/facts',
        method: "GET",
        success: function( data ) {
          self.el.find('#facts_for_channel > div.loading').hide().parent().find('div.facts').html(data);
          self.el.find('.fact-block').factlink();
        }
      });
    }
    
    return this;
  }
});

