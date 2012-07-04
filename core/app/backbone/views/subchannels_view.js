window.SubchannelsView = Backbone.Factlink.CollectionView.extend({
  tagName: "ul",

  initialize: function() {
    this.collection.bind('add',   this.addOneSubchannel, this);
    this.collection.bind('reset', this.resetSubchannels, this);

    this.views = {};
  },

  addOneSubchannel: function(subchannel) {
    var view = new SubchannelItemView({model: subchannel});
    this.views[subchannel.id] = view;
    view.render();
    this.appendHtml(this, view)
  },

  appendHtml: function(collectView, itemView) {
    $(container).find('.contained-channel-description').show();
    if(this.$el.children().length < 3 + 1) { // real children + overflow
      this.$el.prepend(itemView.el);
    } else {
      this.$el.find('.overflow').append(itemView.el);
      $("#more-button").show();
    }
  },

  resetSubchannels: function() {
    _.each(this._views,function(view) { view.close(); });

    this.collection.each(function(subchannel) {
      this.addOneSubchannel(subchannel);
    },this);
  }
});

