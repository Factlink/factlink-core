window.FactRelationSearchResultView = Backbone.View.extend({
  tagName: "li",

  events: {
    "click": "createFactRelation"
  },

  initialize: function() {
    this.useTemplate("facts","_fact_relation_search_result");
  },

  render: function() {
    this.el.innerHTML = Mustache.to_html(this.tmpl, this.model.toJSON(), this.partials);

    return this;
  },

  remove: function() {
    $(this.el).remove();
  },

  createFactRelation: function(e) {

  }
});