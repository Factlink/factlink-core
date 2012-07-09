// monkeypatch which implements this pullrequest by mark:
// https://github.com/derickbailey/backbone.marionette/pull/175

Backbone.Marionette.CollectionView.prototype.render = function(){
  this.triggerBeforeRender();
  this.closeEmptyView();
  this.closeChildren();
  if (this.collection && this.collection.length > 0) {
    this.showCollection();
  } else {
    this.showEmptyView();
  }

  this.triggerRendered();
  return this;
};

Backbone.Marionette.CollectionView.prototype.showEmptyView = function(){
  var EmptyView = this.options.emptyView || this.emptyView;
  if (EmptyView && !this.showingEmptyView){
    this.showingEmptyView = true;
    var model = new Backbone.Model();
    this.addItemView(model, EmptyView, 0);
  }
};
