window.OwnChannelCollectionView = Backbone.View.extend({
  tmpl: $('#own_channels_collection').html(),
  tagName: "div",
  
  _views: [],
  
  events: {
    'submit form': 'addChannel'
  },
    
  initialize: function() {
    this.collection.bind('add',   this.render, this);
    this.collection.bind('reset', this.render, this);
    
    this.containing_channels = currentChannel.get('containing_channels');
    
  },
  
  addChannel: function(e) {
    var self = this;
    
    self.disableAdd();
    
    var val = self.$input.val();
        
    if ( val.length > 0 ) {
      $.ajax({
        url: currentUser.url() + '/channels',
        data: {
          title: val,
          for_channel: currentChannel.id
        },
        type: "post",
        success: function(data) {
          self.containing_channels.push(data.id);
          
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
  
  render: function() {
    var self = this;
    
    this.el
      .html( $.mustache(this.tmpl) );
    
    var $channelListing = this.el.find('ul');
    
    _.each(self.containing_channels, function(containing_channel_id) {
      self.collection.get(containing_channel_id).checked = true;
    });
    
    this.collection.each(function(channel) {
      debugger;
      if ( channel.get('editable?') ) {
        var view = new OwnChannelItemView({model: channel}).render();

        $channelListing.append(view.el);
      }
    });
    
    var el = $( this.el );
    
    this.$input = el.find('input[name="channel_title"]');
    this.$submit = el.find('input[type="submit"]');
  }
});
