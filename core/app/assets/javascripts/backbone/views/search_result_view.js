window.SearchResultView = Backbone.CollectionView.extend({
  tagName: "div",
  className: "search-results",
  _loading: true,
  _page: 1,
  _previousLength: 0,
  
  initialize: function(options) {
    this.useTemplate("search_results", "_search_results");

    var self = this;

    this.collection.bind('add', this.addSearchResultItem, this);
    this.collection.bind('reset', this.resetSearchResultItems, this);

    this.$el.html(Mustache.to_html(this.tmpl, {}, this.partials));
    this.bindScroll();
  },
  
  render: function() {
    if (this.collection.length > 0) {
      this.resetSearchResultItems();
    }

    return this;
  },
  
  addSearchResultItem: function(search_result_item) {
    var view = new SearchResultItemView({
      model: search_result_item
    });

    this.$el.find('.results').append(view.render().el);
  },
  
  resetSearchResultItems: function(e) {
    var self = this;

    this.stopLoading();

    if (this.collection.length === 0) {
      this.showNoFacts();
    } else {
      this.collection.forEach(function(search_result_item) {
        self.addSearchResultItem(search_result_item);
      });
    }

    if ( this._previousLength === this.collection.length ) {
      this.hasMore = false;
    } else {
      this._previousLength = this.collection.length;
    }

    this.loadMore();
  },
  
  _moreNeeded: true,
  
  moreNeeded: function() {
    var bottomOfTheViewport = window.pageYOffset + window.innerHeight;
    var bottomOfEl = this.$el.offset().top + this.$el.outerHeight();

    if ( this.hasMore ) {
      if ( bottomOfEl < bottomOfTheViewport ) {
        return true;
      } else if ($(document).height() - ($(window).scrollTop() + $(window).height()) < 700) {
        return true;
      }
    }
    
    return false;
  },
  
  loadMore: function() {
    var self = this;

    if ( self.moreNeeded() && ! self._loading ) {
      self._page += 1;
      
      self.setLoading();
      self.collection.fetch({
        add: true,
        data: {
          page: self._page
        },
        success: function(collection, response) {
          self.stopLoading();
          if (response.length > 0 ) {
            self.loadMore();            
          } else {
            self.hasMore = false;            
          }
        },
        error: function() {
          self.stopLoading();
          self.hasMore = false;
        }
      });
    }
  },
  
  hasMore: true,
  
  showNoFacts: function() {
    this.$el.find('div.no_results').show();
  },
  
  hideNoFacts: function() {
    this.$el.find('div.no_results').hide();
  },
  
  setLoading: function() {
    this._loading = true;
    this.$el.find('div.loading').show();
  },
  
  stopLoading: function() {
    this._loading = false;
    this.$el.find('div.loading').hide();
  },
  
  //TODO: Unbind on remove?
  bindScroll: function() {
    var self = this;
    $(window).bind('scroll.' + this.cid, function MCBiggah() {
      self.loadMore.apply(self);
    });
  },
  
  unbindScroll: function() {
    $(window).unbind('scroll.' + this.cid);
  }
});
