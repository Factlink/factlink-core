var FactRelationSearchView = Backbone.View.extend({
  events: {
    "keyup input": "doSearch",
    "click a.cancel": "cancelSearch"
  },

  _searchResultViews: [],

  initialize: function() {
    this.useTemplate("fact_relations","_evidence_search");
  },

  render: function() {
    $(this.el).html(Mustache.to_html(this.tmpl, {}, this.partials));

    if ( this.options.type === "supporting" ) {
      $( this.el ).find('.add-evidence.supporting' ).css('display','block');
    } else {
      $( this.el ).find('.add-evidence.weakening' ).css('display','block');
    }

    return this;
  },

  cancelSearch: function(e) {
    this.truncateSearchContainer();

    $('input', this.el).val('');
  },

  doSearch: _.throttle(function() {
    var searchVal = $('input:visible', this.el).val();
    var self = this;

    if ( searchVal.length < 2 ) {
      this.truncateSearchContainer();

      return;
    }

    $.ajax({
      url: this.options.factRelations.fact.url() + "/evidence_search",
      data: {
        s: searchVal
      },
      success: function(searchResults) {
        self.parseSearchResults.call(self, searchResults);
      }
    });
  }, 300),

  parseSearchResults: function(searchResults) {
    var self = this;
    var searchResultsContainer = $(this.el).find('.search-results');

    this.truncateSearchContainer();

    _.forEach(searchResults, function(searchResult) {
      var view = new FactRelationSearchResultView({
        model: new FactRelationSearchResult(searchResult),
        // Give the search result a reference to the FactRelation collection
        factRelations: self.options.factRelations,
        parentView: self
      });

      searchResultsContainer.append( view.render().el );

      self._searchResultViews.push(view);
    });
  },

  truncateSearchContainer: function() {
    _.forEach(this._searchResultViews, function(view) {
      view.remove();
    });

    this._searchResultViews = [];
  }
});