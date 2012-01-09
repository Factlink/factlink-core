window.FactRelationView = Backbone.View.extend({
  tagName: "li",
  className: "fact-relation",

  events: {
    "click .relation-actions>.weakening": "disbelieveFactRelation",
    "click .relation-actions>.supporting": "believeFactRelation"
  },

  initialize: function() {
    this.useTemplate('fact_relations','fact_relation');

    this.model.bind('destroy', this.remove, this);
  },

  remove: function() {
    $(this.el).fadeOut('fast', function() {
      $(this.el).remove();
    });
  },

  render: function() {
    $(this.el).html(Mustache.to_html(this.tmpl, this.model.toJSON(), this.partials)).factlink();

    return this;
  },

  disbelieveFactRelation: function() {
    this.model.disbelieve();
  },

  believeFactRelation: function() {
    this.model.believe();
  }
});