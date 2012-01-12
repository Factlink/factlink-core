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
    var self = this;
    var factRelations = this.options.factRelations;

    $.ajax({
      url: factRelations.url(),
      type: "POST",
      data: {
        fact_id: factRelations.fact.get('id'),
        evidence_id: this.model.get('id')
      },
      success: function(newFactRelation) {
        factRelations.add(new factRelations.model(newFactRelation), {
          highlight: true
        });

        self.options.parentView.cancelSearch();
      }
    });
  }
});