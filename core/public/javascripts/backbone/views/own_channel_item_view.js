window.OwnChannelItemView = Backbone.View.extend({
  tagName: "li",
  tmpl: $('#own_channel_li').html(),
  
  events: {
    "change input" : "change"
  },
  
  initialize: function() {
    this.model.bind('change', this.render, this);
    this.model.bind('destroy', this.remove, this);
    this.model.bind('remove', this.remove, this);
  },
  
  render: function() {
    $( this.el )
      .html( Mustache.to_html(this.tmpl, this.model.toJSON() ));
    
    $( this.el ).find('input').prop('checked', this.model.checked === true ? true : false);
    
    return this;
  },

  remove: function() {
    $( this.el ).remove();
  },
  
  disable: function() {
    $( this.el ).find('input').prop('disabled',true);
  },
  
  enable: function() {
    $( this.el ).find('input').prop('disabled',false);
  },
  
  change: function( e ) {
    var self = this;
    var checked = e.target.checked;
    var action = checked ? "add" : "remove";
    
    self.disable();
    
    $.ajax({
      url: this.model.url() + '/subchannels/' + action + '/' + currentChannel.id + '.json',
      type: "post",
      success: function(data) {
        if ( checked ) {
          currentChannel.get('containing_channels').push(self.model.id);
        } else {
          var indexOf = currentChannel.get('containing_channels').indexOf(self.model.id);
          if ( indexOf ) {
            currentChannel.get('containing_channels').splice(indexOf, 1);
          }
        }
        
        self.enable();
      },
      error: function() {
        e.target.checked = newValue;
        
        self.enable();
      }
    });
  }
});
