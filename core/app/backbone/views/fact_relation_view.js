var ViewWithPopover = extendWithPopover( Backbone.Factlink.PlainView );

window.FactRelationView = ViewWithPopover.extend({
  tagName: "li",
  className: "fact-relation",

  events: {
    "click .relation-actions>.weakening": "disbelieveFactRelation",
    "click .relation-actions>.supporting": "believeFactRelation",
    "click li.delete": "destroyFactRelation"
  },

  template: 'fact_relations/fact_relation',

  partials: {
    fact_base: "facts/_fact_base",
    fact_wheel: "facts/_fact_wheel"
  },

  popover: [
    {
      selector: ".relation-top-right-arrow",
      popoverSelector: "ul.relation-top-right"
    }
  ],

  initialize: function() {
    this.model.bind('destroy', this.remove, this);
    this.model.bind('change', this.render, this);
  },

  remove: function() {
    var $el = this.$el;

    $el.fadeOut('fast', function() {
      $el.remove();
    });
  },

  destroyFactRelation: function () {
    this.model.destroy();
  },

  render: function() {
    $('a.weakening',this.$el).tooltip('hide');
    $('a.supporting',this.$el).tooltip('hide');

    this.$el.html(this.templateRender(this.model.toJSON()));

    this.wheelView = new InteractiveWheelView({
      el: this.$el.find('.fact-wheel'),
      fact: this.model.get("fact_base"),
      model: new Wheel(this.model.get('fact_base')['fact_wheel'])
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
