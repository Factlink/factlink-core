var FactRelationSearchView = Backbone.View.extend({
  events: {
    "keyup input": "doSearchOrSubmit",
    "click li.add": "addNewFactRelation"
  },

  template: "fact_relations/_evidence_search",

  initialize: function(){
    this._busyAdding = false;
    this._lastKnownSearch = "";
    this._searchResultViews = [];
  },

  render: function() {
    this.$el.html(this.templateRender());

    if ( this.options.type === "supporting" ) {
      this.$el.find('.add-evidence.supporting' ).css('display','block');
    } else {
      this.$el.find('.add-evidence.weakening' ).css('display','block');
    }

    return this;
  },

  cancelSearch: function(e) {
    this.truncateSearchContainer();

    $('input', this.el).val('');
  },

  doSearchOrSubmit: function(e) {

    if (e.keyCode === 13) {
      var searchVal = $('input:visible', this.el).val();
      if (searchVal.trim().length > 0 ) {
        this._lastKnownSearch = searchVal;
        this.addNewFactRelation();
      }
    } else {
      this.doSearch();
    }
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

        self.$el
          .find('li.add>span.word')
          .text(searchVal)
          .closest('li')
          .show();

        mp_track("Evidence: Search", {type: self.options.type});

        self.stopLoading();
      }
    });
  }, 300),

  parseSearchResults: function(searchResults) {
    var self = this;
    var searchResultsContainer = this.$el.find('.search-results');

    this.truncateSearchContainer();

    _.forEach(searchResults, function(searchResult) {
      var view = new FactRelationSearchResultView({
        model: new FactRelationSearchResult(searchResult),
        // Give the search result a reference to the FactRelation collection
        factRelations: self.options.factRelations,
        parentView: self
      });

      view.render()
      searchResultsContainer.find('li.loading').after( view.el );

      self._searchResultViews.push(view);
    });
  },

  addNewFactRelation: function() {
    var self = this;

    if ( self._busyAdding ) {
      return;
    } else {
      self._busyAdding = true;
    }

    var factRelations = self.options.factRelations;

    self.setAddingIndicator();

    $.ajax({
      url: factRelations.url(),
      type: "POST",
      data: {
        fact_id: factRelations.fact.get('id'),
        displaystring: this._lastKnownSearch
      },
      success: function(newFactRelation) {
        mp_track("Evidence: Create", {
          factlink_id: self.options.factRelations.fact.id,
          type: self.options.type
        });

        factRelations.add(new factRelations.model(newFactRelation), {
          highlight: true
        });
        self._busyAdding = false;
        self.cancelSearch();
        self.stopAddingIndicator();
      },
      error: function() {
        self._busyAdding = false;
        self.cancelSearch();
        self.stopAddingIndicator();
      }
    });
  },

  truncateSearchContainer: function() {
    _.forEach(this._searchResultViews, function(view) {
      view.close();
    });

    this.$el.find('li.add').hide();

    this._searchResultViews = [];
  },

  setLoading: function() {
    this.$el.find('li.loading').show();
  },

  stopLoading: function() {
    this.$el.find('li.loading').hide();
  },

  setAddingIndicator: function() {
    this.$el.find('.add img').show();
    this.$el.find('.add .add-message').text('Adding');
  },
  stopAddingIndicator: function() {
    this.$el.find('.add img').hide();
    this.$el.find('.add .add-message').text('Add');
  }
});
_.extend(FactRelationSearchView.prototype, TemplateMixin);