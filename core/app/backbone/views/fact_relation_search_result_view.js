window.FactRelationSearchResultView = Backbone.View.extend({
  tagName: "li",

  events: {
    "click": "createFactRelation"
  },

  tmpl: Template.use("facts", "_fact_relation_search_result"),

  render: function() {
    this.el.innerHTML = this.tmpl.render(this.model.toJSON());

    return this;
  },

  remove: function() {
    this.$el.remove();
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
        mp_track("Evidence: Create", {
          factlink_id: factRelations.fact.id,
          evidence_id: self.model.get('id')
        });

        factRelations.add(new factRelations.model(newFactRelation), {
          highlight: true
        });

        self.options.parentView.cancelSearch();
      }
    });
  }
});
