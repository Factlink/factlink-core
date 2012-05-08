window.FactRelationView = Backbone.View.extend({
  tagName: "li",
  className: "fact-relation",

  events: {
    "click .relation-actions>.weakening": "disbelieveFactRelation",
    "click .relation-actions>.supporting": "believeFactRelation",
    "click .remove-relation": "destroyFactRelation"
  },

  tmpl: Template.use('fact_relations','fact_relation'),

  initialize: function() {
    this.model.bind('destroy', this.remove, this);
    this.model.bind('change', this.render, this);
  },

  remove: function() {
    this.$el.fadeOut('fast', function() {
      this.$el.remove();
    });
  },

  destroyFactRelation: function () {
    if ( confirm("Are you sure you want to remove this Factlink from the list of evidence?") ) {
      this.model.destroy();
    }
  },

  render: function() {
    $('a.weakening',this.$el).tooltip('hide');
    $('a.supporting',this.$el).tooltip('hide');

    this.$el.html(this.tmpl.render(this.model.toJSON(), {
      fact_bubble: Template.use("facts", "_fact_bubble"),
      fact_wheel: Template.use("facts", "_fact_wheel")
    }));

    this.wheelView = new InteractiveWheelView({
      el: this.$el.find('.wheel'),
      model: new Wheel(this.model.get('fact_bubble')['fact_wheel'])
    }).render();

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
