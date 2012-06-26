//= require jquery.scrollTo

window.FactRelationsView = Backbone.View.extend({
  tagName: "div",
  className: "page evidence-list fact-relations-container",
  _views: [],
  _loading: true,

  template: 'fact_relations/fact_relations',

  initialize: function(options) {
    this.collection.bind('add', this.addFactRelation, this);
    this.collection.bind('remove', this.removeFactRelation, this);
    this.collection.bind('reset', this.resetFactRelations, this);

    this.showNoEvidenceMessage();

    this.initializeSearchView();
  },

  initializeSearchView: function() {
    this.factRelationSearchView = new FactRelationSearchView({
      factRelations: this.collection,
      type: this.options.type
    });
  },

  highlightFactRelation: function(view) {
    $( 'ul.evidence-listing', this.el)
      .scrollTo(view.el, 800);

    view.highlight();
  },

  addFactRelation: function(factRelation, factRelations, options) {
    if ( !options ) {
      options = {};
    }

    var factRelationView = new FactRelationView({model: factRelation});

    this.hideNoEvidenceMessage();

    this._views.push(factRelationView);

    factRelationView.render();
    this.$el.find('ul.evidence-listing').append(factRelationView.el);

    if ( options.highlight ) {
      this.highlightFactRelation(factRelationView);
    }
  },

  resetFactRelations: function() {
    var self = this;

    this.collection.forEach(function(factRelation) {
      self.addFactRelation(factRelation);
    });

    if ( this.collection.length === 0 ) {
      this.showNoEvidenceMessage();
    }
  },

  removeFactRelation: function(factRelation) {
    console.info( "Removing one FactRelation" );
  },

  render: function() {
    this.$el
      .html(this.templateRender())
      .prepend(this.factRelationSearchView.render().el);

    return this;
  },

  hide: function() {
    this.$el.hide();
  },

  show: function() {
    this.$el.show();
  },

  showAndFetch: function() {
    var self = this;

    if ( ! this._fetched ) {
      this._fetched = true;

      this.collection.reset();

      this.showLoadingIndicator();

      this.collection.fetch({
        success: function() {
          self.hideLoadingIndicator();
        }
      });
    }

    this.$el.show();
  },

  showLoadingIndicator: function() {
    this.$el.find('.loading-evidence').show();
    this.hideNoEvidenceMessage();
  },

  hideLoadingIndicator: function() {
    this.$el.find('.loading-evidence').hide();
  },

  showNoEvidenceMessage: function() {
    this.$el.find('.no-evidence-message').show();
    this.hideLoadingIndicator();
  },

  hideNoEvidenceMessage: function() {
    this.$el.find('.no-evidence-message').hide();
  }
});
_.extend(FactRelationsView.prototype, TemplateMixin);