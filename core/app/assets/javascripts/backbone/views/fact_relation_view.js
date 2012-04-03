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
    this.$el.fadeOut('fast', function() {
      this.$el.remove();
    });
  },

  render: function() {
    $('a.weakening',this.$el).tooltip('hide');
    $('a.supporting',this.$el).tooltip('hide');

    this.$el.html(Mustache.to_html(this.tmpl, this.model.toJSON(), this.partials)).factlink();

    $('a.supporting',this.$el).tooltip({'title':"This is relevant"});
    $('a.weakening',this.$el).tooltip({'title':"This is not relevant", 'placement':'bottom'});

    var weight = this.model.get("weight");
    var weightTooltipText = "This fact influences the top fact a lot";

    if ( weight < 33 ) {
      weightTooltipText = "This fact doesn't influence the top fact that much";
    } else if ( weight < 66 ) {
      weightTooltipText = "This fact influences the top fact a little bit";
    }

    this.$el.find('.weight-container').tooltip({title: weightTooltipText});

    return this;
  },

  disbelieveFactRelation: function() {
    this.model.disbelieve();
  },

  believeFactRelation: function() {
    this.model.believe();
  },

  highlight: function() {
    var self = this;
    self.$el.animate({"background-color": "#ffffe1"}, {duration: 2000, complete: function() {
      $(this).animate({"background-color": "#ffffff"}, 2000);
    }});
  }
});
