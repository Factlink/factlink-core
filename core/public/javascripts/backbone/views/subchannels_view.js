window.SubchannelsView = Backbone.View.extend({
  tagName: "ul",
  
  initialize: function() {
    this.collection.bind('add',   this.addOneSubchannel, this);
    this.collection.bind('reset', this.resetSubchannels, this);
    
    this._views = [];
  },
  
  addOneSubchannel: function(subchannel) {
    var view = new SubchannelItemView({model: subchannel});
    
    this._views[subchannel.id] = view;
    
    this.el.append(view.render().el);
  },
  
  resetSubchannels: function() {
    var self = this;
    
    _.each(this._views,function(view) {
      view.remove();
    });
    
    this.collection.each(function(subchannel) {
      self.addOneSubchannel.call(self, subchannel);
    });
  }
});

