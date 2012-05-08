window.SupportingFactRelations = window.FactRelations.extend({
  url: function() {
    return this.fact.url() + '/supporting_evidence';
  },
  type: "supporting"
});