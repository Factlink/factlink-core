window.FactsView = Backbone.View.extend({
  tagName: "div",
  className: "facts",
  _loading: true,
  _page: 1,
  tmpl: $('#facts_tmpl').html(),
  _previousLength: 0,
  
  initialize: function() {
    var self = this;

    this.collection.bind('add', this.addFact, this);
    this.collection.bind('reset', this.resetFacts, this);

    $(this.el).html(Mustache.to_html(this.tmpl));
    
    this.bindScroll();
  },
  
  render: function() {
    if (this.collection.length > 0) {
      this.resetFacts();
    }

    return this;
  },
  
  remove: function() {
    Backbone.View.prototype.remove.apply(this);
    
    this.unbindScroll();
  },
  
  addFact: function(fact) {
    var view = new FactView({
      model: fact
    });

    $(this.el).find('.facts').append(view.render().el);
  },
  
  resetFacts: function(e) {
    var self = this;

    this.stopLoading();

    if (this.collection.length === 0) {
      this.showNoFacts();
    } else {
      this.collection.forEach(function(fact) {
        self.addFact(fact);
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
    
    if ( self.moreNeeded() && ! self._loading ) {
      self.setLoading();
      
      self._page += 1;

      self.collection.fetch({
        add: true,
        data: {
          page: self._page
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
    $(this.el).find('div.no_facts').show();
  },
  
  hideNoFacts: function() {
    $(this.el).find('div.no_facts').hide();
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
    $(window).bind('scroll.' + this.cid, function fugglyWrapper() {
      self.loadMore.apply(self);
    });
  },
  
  unbindScroll: function() {
    $(window).unbind('scroll.' + this.cid);
  }
});
