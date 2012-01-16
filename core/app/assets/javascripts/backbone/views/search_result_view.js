window.SearchResultView = Backbone.View.extend({
  tagName: "div",
  className: "search-results",
  _loading: true,
  _timestamp: undefined,
  _previousLength: 0,
  
  initialize: function(options) {
    this.useTemplate("search_results", "_search_results");

    var self = this;

    this.collection.bind('add', this.addSearchResultItem, this);
    this.collection.bind('reset', this.resetSearchResultItems, this);

    $(this.el).html(Mustache.to_html(this.tmpl, {}, this.partials));
    this.bindScroll();
  },
  
  render: function() {
    if (this.collection.length > 0) {
      this.resetSearchResultItems();
    }

    return this;
  },
  
  remove: function() {
    Backbone.View.prototype.remove.apply(this);
    
    this.unbindScroll();
  },
  
  addSearchResultItem: function(search_result_item) {
    var view = new SearchResultItemView({
      model: search_result_item
    });

    $(this.el).find('.results').append(view.render().el);
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
    var bottomOfEl = $(this.el).offset().top + $(this.el).outerHeight();
    
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
    var lastModel = self.collection.models[(self.collection.length - 1) || 0];
    var new_timestamp = (lastModel ? lastModel.get('timestamp') : 0);
    
    if ( self.moreNeeded() && ! self._loading && self._timestamp !== new_timestamp ) {
      self.setLoading();
      
      self._timestamp = new_timestamp;

      self.collection.fetch({
        add: true,
        data: {
          timestamp: self._timestamp
        },
        success: function() {
          self.stopLoading();
          self.loadMore();
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
    $(this.el).find('div.no_results').show();
  },
  
  hideNoFacts: function() {
    $(this.el).find('div.no_results').hide();
  },
  
  setLoading: function() {
    this._loading = true;
    $(this.el).find('div.loading').show();
  },
  
  stopLoading: function() {
    this._loading = false;
    $(this.el).find('div.loading').hide();
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
