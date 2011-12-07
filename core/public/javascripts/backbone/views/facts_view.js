window.FactsView = Backbone.View.extend({
  tagName: "div",
  className: "facts",
  _loading: true,
  _page: 1,
  tmpl: $('#facts_tmpl').html(),
  
  initialize: function() {
    var self = this;

    this.collection.bind('add', this.addFact, this);
    this.collection.bind('reset', this.resetFacts, this);

    $(this.el).html(Mustache.to_html(this.tmpl));

    this.setLoading();

    this.collection.fetch({
      data: {
        page: self._page
      }
    });
  },
  
  render: function() {
    if (this.collection.length > 0) {
      this.resetFacts();
    }

    return this;
  },
  
  addFact: function(fact) {
    var view = new FactView({
      model: fact
    });

    $(this.el).append(view.render().el);
  },
  
  resetFacts: function() {
    var self = this;

    this.stopLoading();

    if (this.collection.length === 0) {
      this.showNoFacts();
    } else {
      this.collection.forEach(function(fact) {
        self.addFact(fact);
      });
    }
  },
  
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
  }
});
