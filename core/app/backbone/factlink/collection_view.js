Backbone.Factlink = Backbone.Factlink || {};

Backbone.Factlink.CollectionView = Backbone.View.extend({
  beforeReset: function(e){},
  afterReset: function(e){},

  reset: function(e) {
    this.beforeReset.apply(this, arguments);
    _.each(this.views,function(view) {
      view.close();
    });

    this.views = {};

    this.render();
    this.afterReset.apply(this, arguments);
  },

  beforeAdd: function(model){},
  afterAddBeforeRender: function(model,view){},
  afterAdd: function(model){},
  add: function(model, collection, opts) {
    this.beforeAdd.apply(this,arguments);
    var view = new this.itemView({
      model: model
    });

    this.views[model.cid] = view;

    view.render();

    //TODO: Also allow to add views in the middle of the collection
    if ( opts && opts.at === 0 ) {
      this.$el.find(this.itemViewContainer).prepend(view.el);
    } else {
      this.$el.find(this.itemViewContainer).append(view.el);
    }

    this.afterAdd.apply(this, arguments);
  },

  render: function() {
    var self = this;

    this.collection.each(function(model) {
      self.add.call(self, model);
    });
    return this;
  }

});
