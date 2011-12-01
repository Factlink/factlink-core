window.FactsView = Backbone.View.extend({
  tagName: "div",
  className: "facts",
  _views: [],
  _loading: false,
  _page: 1,
  tmpl: $('#facts_tmpl').html(),
  initialize: function() {
    var self = this;
    
    this.collection.bind('add', this.addFact, this);
    this.collection.bind('reset', this.resetFacts, this);
    
    $(this.el).html(Mustache.to_html(this.tmpl));
    
    this.collection.fetch({
      data: {
        page: self._page
      }
    });
  },
  render: function() {
    if ( this.collection.length > 0 ) {
      this.resetFacts();
    }
    
    return this;
  },
  addFact: function(fact) {
    var view = new FactView({
      model: fact
    });
    
    $( this.el ).append(view.render().el);
    
    this._views.push(view);
  },
  resetFacts: function() {
    var self = this;
    
    $(this.el).find('div.loading').hide();
    
    $(this.el).find('div.no_facts').toggle(this.collection.length);
    
    this.collection.forEach(function(fact) {
      self.addFact(fact);
    });
  }
});