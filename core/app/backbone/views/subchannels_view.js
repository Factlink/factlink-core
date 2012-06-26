window.SubchannelsView = Backbone.Factlink.CollectionView.extend({
  tagName: "ul",

  initialize: function() {
    this.collection.bind('add',   this.addOneSubchannel, this);
    this.collection.bind('reset', this.resetSubchannels, this);

    this.views = {};
  },

  addOneSubchannel: function(subchannel, count) {
    var view = new SubchannelItemView({model: subchannel});
    this.views[subchannel.id] = view;
    view.render();
    if(count < 3) {
      this.$el.prepend(view.el);
    } else {
      this.$el.find('.overflow').append(view.el);
    }

  },

  resetSubchannels: function() {
    _.each(this._views,function(view) { view.close(); });

    var count = 0;

    var subchannelSize = this.collection.size();
    if(subchannelSize !== 0) { $(container).find('.contained-channel-description').show(); }
    if(subchannelSize > 3) {
      $("#more-button").show();
    }

    this.collection.each(function(subchannel) {
      this.addOneSubchannel.call(this, subchannel, count);
      count++;
    },this);
  }
});

