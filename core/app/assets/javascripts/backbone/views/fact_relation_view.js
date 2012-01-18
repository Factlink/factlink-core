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
    this.model.bind('change', this.render, this);
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
  },

  highlight: function() {
    // TODO: Joel, could you specify some highlighting here? <3 <3
    //       Tried to do it, but don't know on which element I should set the
    //       styles :( <3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3
    // Color fade out in JS required a jQuery plugin? Only giving new background color now.
    $(this.el).addClass('highlighted');
  }
});