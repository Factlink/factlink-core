Backbone.CollectionView = Backbone.View.extend({
  views: {},

  beforeReset: function(e){},
  afterReset: function(e){},

  reset: function(e) {
    this.beforeReset();
    _.each(this.views,function(view) {
      view.remove();
    });
    this.render();
    this.afterReset();
  },

  beforeAdd: function(model){},
  afterAddBeforeRender: function(model,view){},
  afterAdd: function(model){},
  add: function(model,opts) {
    this.beforeAdd(model,opts);
    var view = new this.modelView({
      model: model
    });
    this.views[model.id] = view;
    this.$el.find(this.containerSelector).append(view.render().el);
    this.afterAdd(model,opts);
  },

  render: function() {
    var self = this;

    this.collection.each(function(model) {
      self.add.call(self, model);
    });
    return this;
  }

});