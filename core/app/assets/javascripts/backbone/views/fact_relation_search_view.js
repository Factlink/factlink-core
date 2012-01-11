var FactRelationSearchView = Backbone.View.extend({
  events: {
    "keyup input": "doSearch"
  },

  _searchResultViews: [],

  initialize: function() {
    this.useTemplate("facts","_evidence_as_search_result");
  },

  doSearch: _.throttle(function() {
    var searchVal = $('input', this.el).val();
    var self = this;

    if ( searchVal.length < 2 ) {
      this.truncateSearchContainer();

      return;
    }

    $.ajax({
      url: this.model.url() + "/evidence_search",
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
    var searchResultsContainer = this.el.find('.search-results');

    this.truncateSearchContainer();

    _.forEach(searchResults, function(searchResult) {
      var view = new FactRelationSearchResultView({
        model: new FactRelationSearchResult(searchResult)
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