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
    if ( this.el.find('#add_to_channel') ) {
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

  render: function() { 
    var self = this;

    if ( self.model ) {
      self.model.trigger('loading');
      
      this.el
        .html( $.mustache(this.tmpl, this.model.toJSON() ));
      
      this.initSubChannels();
      
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

