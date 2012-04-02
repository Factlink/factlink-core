Backbone.CollectionView = Backbone.View.extend({
  beforeReset: function(e){},
  afterReset: function(e){},

  reset: function(e) {
    this.beforeReset.apply(this, arguments);
    _.each(this.views,function(view) {
      view.remove();
    });

    this.views = {};

    this.render();
    this.afterReset.apply(this, arguments);
  },

  beforeAdd: function(model){},
  afterAddBeforeRender: function(model,view){},
  afterAdd: function(model){},
  add: function(model,opts) {
    this.beforeAdd.apply(this,arguments);
    var view = new this.modelView({
      model: model
    });

    this.views[model.cid] = view;
    this.$el.find(this.containerSelector).append(view.render().el);
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