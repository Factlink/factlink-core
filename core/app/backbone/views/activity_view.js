window.GenericActivityView = Backbone.View.extend({
  tagName: "div",
  className: "activity-block",

  tmpl: Template.use("activities", "_generic_activity"),

  render: function() {
    this.$el.html( this.tmpl.render(this.model.toJSON()) );
    $('#activity_for_channel').append(this.$el);
    return this;
  },

  clickHandler: function(e) {
    document.location.href = this.model.url();
  }
});

ActivityAddedEvidenceView = GenericActivityView.extend({
  tmpl: Template.use("activities", "_added_evidence_activity"),

  render: function() {
    GenericActivityView.prototype.render.apply(this);
    var factView = new FactView({
      el: this.$el.find('.fact-block'),
      model: new Fact(this.model.get('activity')['fact'])
    }).render();
    return this;
  }
});

ActivityCreatedChannelView = GenericActivityView.extend({
  tmpl: Template.use("activities", '_created_channel_activity')
});

ActivityAddedSubchannelView = GenericActivityView.extend({
  tmpl: Template.use("activities", "_added_subchannel_activity")
});

ActivityAddedOpinionView = GenericActivityView.extend({
  tmpl: Template.use("activities", "_added_opinion_activity"),

  render: function() {
    GenericActivityView.prototype.render.apply(this);

    var factView = new FactView({
      el: this.$el.find('.fact-block'),
      model: new Fact(this.model.get('activity')['fact'])
    }).render();

    return this;
  }
});

ActivityWasFollowedView = GenericActivityView.extend({});

window.ActivityView = function(opts) {

  switch (opts.model.get("action")) {

    case "added_supporting_evidence":
    case "added_weakening_evidence":
      return new ActivityAddedEvidenceView(opts);

    case "created_channel":
      return new ActivityCreatedChannelView(opts);

    case "added_subchannel":
      return new ActivityAddedSubchannelView(opts);

    case "believes":
    case "doubts":
    case "disbelieves":
      return new ActivityAddedOpinionView(opts);

    default:
      return new GenericActivityView(opts);
  }
};
