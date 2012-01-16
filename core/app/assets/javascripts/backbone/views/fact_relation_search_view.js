var FactRelationSearchView = Backbone.View.extend({
  events: {
    "keyup input": "doSearch",
    "click li.add": "addNewFactRelation"
  },

  _lastKnownSearch: "",

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

    if ( searchVal.length < 2 && searchVal !== this._lastKnownSearch ) {
      this.truncateSearchContainer();

      return;
    }

    this._lastKnownSearch = searchVal;

    this.setLoading();

    $.ajax({
      url: this.options.factRelations.fact.url() + "/evidence_search",
      data: {
        s: searchVal
      },
      success: function(searchResults) {
        self.parseSearchResults.call(self, searchResults);

        $( self.el )
          .find('li.add>span.word')
          .text(searchVal)
          .closest('li')
          .show();

        self.stopLoading();
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

      searchResultsContainer.find('li.loading').after( view.render().el );

      self._searchResultViews.push(view);
    });
  },

  addNewFactRelation: function(e) {
    var self = this;
    var factRelations = self.options.factRelations;

    $.ajax({
      url: factRelations.url(),
      type: "POST",
      data: {
        fact_id: factRelations.fact.get('id'),
        displaystring: this._lastKnownSearch
      },
      success: function(newFactRelation) {
        factRelations.add(new factRelations.model(newFactRelation), {
          highlight: true
        });

        self.cancelSearch();
      }
    });
  },

  truncateSearchContainer: function() {
    _.forEach(this._searchResultViews, function(view) {
      view.remove();
    });

    $( this.el ).find('li.add').hide();

    this._searchResultViews = [];
  },

  setLoading: function() {
    $( this.el ).find('li.loading').show();
  },

  stopLoading: function() {
    $( this.el ).find('li.loading').hide();
  }
});
