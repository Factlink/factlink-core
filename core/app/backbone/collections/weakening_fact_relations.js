window.WeakeningFactRelations = FactRelations.extend({
  url: function() {
    return this.fact.url() + '/weakening_evidence';
  },
  type: "weakening"
});