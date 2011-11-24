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
      .html( $.mustache(this.tmpl, this.model.toJSON() ));
    
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
        self.enable();
      },
      error: function() {
        e.target.checked = !checked;
        
        self.enable();
      }
    });
  }
});
