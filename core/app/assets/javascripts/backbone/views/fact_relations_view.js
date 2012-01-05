window.FactRelationsView = Backbone.View.extend({
  tagName: "div",
  className: "page evidence-list fact-relations-container",
  _views: [],

  initialize: function(options) {
    this.useTemplate('fact_relations','fact_relations');

    this.collection.bind('add', this.addFactRelation, this);
    this.collection.bind('remove', this.removeFactRelation, this);
    this.collection.bind('reset', this.resetFactRelations, this);
  },

  addFactRelation: function(factRelation) {
    var factRelationView = new FactRelationView({model: factRelation});
    this._views.push(factRelationView);

    $(this.el).find('ul').append(factRelationView.render().el);
  },

  resetFactRelations: function() {
    var self = this;

    this.collection.forEach(function(factRelation) {
      self.addFactRelation(factRelation);
    });
  },

  removeFactRelation: function(factRelation) {
    console.info( "Removing one FactRelation" );
  },

  render: function() {
    $(this.el).html(Mustache.to_html(this.tmpl, {}, this.partials));

    return this;
  },

  hide: function() {
    $(this.el).hide();
  },

  showAndFetch: function() {
    if ( ! this._fetched ) {
      this._fetched = true;

      this.collection.reset().fetch();
    }

    $(this.el).show();
  }
});