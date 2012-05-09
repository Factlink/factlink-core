window.ExtendedFact = Fact.extend({
  url: function() {
    return '/facts/' + this.get('id');
  },

  setTitle: function (title, options) {
    return this.set('fact_title', title, options);
  },

  getTitle: function() {
    return this.get('fact_title');
  },
});
