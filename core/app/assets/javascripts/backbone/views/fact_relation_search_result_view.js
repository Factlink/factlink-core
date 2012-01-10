window.FactRelationSearchResultView = Backbone.View.extend({
  tagName: "li",

  initialize: function() {
    this.useTemplate("facts","_fact_relation_search_result");
  },

  render: function() {
    this.el.innerHTML = Mustache.to_html(this.tmpl, this.model.toJSON(), this.partials);

    return this;
  }
});