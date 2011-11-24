window.OwnChannelCollectionView = Backbone.View.extend({
  tmpl: $('#own_channels_collection').html(),
  tagName: "div",
  
  _views: [],
  
  initialize: function() {
    OwnChannelList.bind('add',   this.addOneChannel, this);
    OwnChannelList.bind('reset', this.render, this);
  },
  
  render: function() {
    var self = this;
    
    this.el
      .html( $.mustache(this.tmpl) );
    
    var $channelListing = this.el.find('ul');
    
    this.collection.each(function(channel) {
      var view = new OwnChannelItemView({model: channel}).render();
      
      $channelListing.append(view.el);
    });
  }
});
