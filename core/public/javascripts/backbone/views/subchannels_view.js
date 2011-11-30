window.SubchannelsView = Backbone.View.extend({
  tagName: "ul",
  
  initialize: function() {
    this.collection.bind('add',   this.addOneSubchannel, this);
    this.collection.bind('reset', this.resetSubchannels, this);
    
    this._views = [];
  },
  
  addOneSubchannel: function(subchannel, count) {
    var view = new SubchannelItemView({model: subchannel});
    this._views[subchannel.id] = view;
    
    var item = view.render().el;
    if(count < 3) { 
      this.el.prepend(item);
    } else { 
      this.el.find('.overflow').append(item);
    }

  },
  
  resetSubchannels: function() {
    var self = this;
    
    _.each(this._views,function(view) {
      view.remove();
    });

    var count = 0;
    if(this.collection.size() > 3) {
      $("#more-button").show();
    }
    this.collection.each(function(subchannel) {
      self.addOneSubchannel.call(self, subchannel, count);
      count++;
    });
  }
});

