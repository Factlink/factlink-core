window.FactRelationsView = Backbone.View.extend({
  tagName: "div",
  className: "page evidence-list fact-relations-container",
  _views: [],
  _loading: true,

  initialize: function(options) {
    this.useTemplate('fact_relations','fact_relations');

    this.collection.bind('add', this.addFactRelation, this);
    this.collection.bind('remove', this.removeFactRelation, this);
    this.collection.bind('reset', this.resetFactRelations, this);

    this.showNoEvidenceMessage();
  },

  addFactRelation: function(factRelation) {
    var factRelationView = new FactRelationView({model: factRelation});

    this.hideNoEvidenceMessage();

    this._views.push(factRelationView);

    $(this.el).find('ul').append(factRelationView.render().el);
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
    $(this.el).html(Mustache.to_html(this.tmpl, {}, this.partials));

    return this;
  },

  hide: function() {
    $(this.el).hide();
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

    $(this.el).show();
  },

  showLoadingIndicator: function() {
    $(this.el).find('.loading-evidence').show();
    this.hideNoEvidenceMessage();
  },

  hideLoadingIndicator: function() {
    $(this.el).find('.loading-evidence').hide();
  },

  showNoEvidenceMessage: function() {
    $(this.el).find('.no-evidence-message').show();
    this.hideLoadingIndicator();
  },

  hideNoEvidenceMessage: function() {
    $(this.el).find('.no-evidence-message').hide();
  }
});