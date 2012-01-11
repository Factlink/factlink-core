window.AddToChannelView = Backbone.View.extend({
  tagName: "div",
  
  _views: [],
  
  events: {
    'submit form': 'addChannel'
  },
    
  initialize: function(opts) {
    this.useTemplate("channels", "_own_channel_listing");
    
    this.collection.bind('add',   this.render, this);
    this.collection.bind('reset', this.render, this);
    
    this.containingChannels = this.model.getOwnContainingChannels();
    
    if ( opts.forChannel ) {
      this.forChannel = opts.forChannel;
    } else if ( opts.forFact ) {
      this.forFact = opts.forFact;
    } else {
      this.forChannel = currentChannel;
    }
  },
  
  addChannel: function(e) {
    e.preventDefault();
    
    var self = this;
    
    self.disableAdd();
    
    var val = self.$input.val();
        
    if ( val.length > 0 ) {
      var dataHolder = {
        title: val
      };
      
      if ( self.forChannel ) {
        dataHolder.for_channel= self.forChannel.id;
      } else {
        dataHolder.for_fact = self.forFact.id;
      }
      
      $.ajax({
        url: '/' + currentUser.get('username') + '/channels',
        data: dataHolder,
        type: "post",
        success: function(data) {
          self.model.get('containing_channel_ids').push(data.id);
          
          currentUser.channels.add(data);
          
          self.resetAdd();
          self.enableAdd();
        }
      });
    } else {
      self.enableAdd();
    }
    
    return false;
  },
  
  resetAdd: function() {
    this.$input.val('');
  },
  
  disableAdd: function() {
    this.$input.prop('disabled',true);
    this.$submit.prop('disabled',true);
  },
  
  enableAdd: function() {
    this.$input.prop('disabled',false);
    this.$submit.prop('disabled',false);
  },
  
  resetCheckedState: function() {
    var containingChannels = _.map(this.model.getOwnContainingChannels(), function(ch) {
      return ch.id;
    });
    
    this.collection.each(function(channel) {
      if ( channel.get('editable?') ) {
        channel.checked = false;
        
        if (_.indexOf(containingChannels,channel.id) !== -1 ) {
          channel.checked = true;
        }
      }
    });
  },
  
  render: function() {
    var self = this;
    
    this.el
      .html( Mustache.to_html(this.tmpl) );

    var $channelListing = this.el.find('ul');
    
    this.resetCheckedState();
    
    this.collection.each(function(channel) {
      if ( channel.get('editable?') ) {
        var view = new OwnChannelItemView(
          {
            model: channel,
            forChannel: self.forChannel,
            forFact: self.forFact
          }).render();

        $channelListing.append(view.el);
      }
    });
    
    this.$input = this.el.find('input[name="channel_title"]');
    this.$submit = this.el.find('input[type="submit"]');
    
    return this;
  }
});
