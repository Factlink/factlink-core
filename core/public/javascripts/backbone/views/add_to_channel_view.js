window.AddToChannelView = Backbone.View.extend({
  tmpl: $('#own_channels_collection').html(),
  tagName: "div",
  
  _views: [],
  
  events: {
    'submit form': 'addChannel'
  },
    
  initialize: function(opts) {
    this.collection.bind('add',   this.render, this);
    this.collection.bind('reset', this.render, this);
    
    this.containingChannels = opts.containingChannels;
  },
  
  addChannel: function(e) {
    console.info( "BAM" );
    var self = this;
    
    self.disableAdd();
    
    var val = self.$input.val();
        
    if ( val.length > 0 ) {
      $.ajax({
        url: '/' + currentUser.get('username') + '/channels',
        data: {
          title: val,
          for_channel: currentChannel.id
        },
        type: "post",
        success: function(data) {
          self.containingChannels.push(data);
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
    var containingChannels = _.map(this.containingChannels, function(ch) {
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
    this.el
      .html( Mustache.to_html(this.tmpl) );

    var $channelListing = this.el.find('ul');
    
    this.resetCheckedState();
    
    this.collection.each(function(channel) {
      if ( channel.get('editable?') ) {
        var view = new OwnChannelItemView({model: channel}).render();

        $channelListing.append(view.el);
      }
    });
    
    this.$input = this.el.find('input[name="channel_title"]');
    this.$submit = this.el.find('input[type="submit"]');
    
    return this;
  }
});
