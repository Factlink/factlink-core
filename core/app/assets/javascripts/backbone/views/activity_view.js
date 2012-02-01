window.GenericActivityView = Backbone.View.extend({
  tagName: "div",
  className: "activity-block",

  initialize: function(options) {
    this.useTemplate("activities", "_generic_activity");
  },

  render: function() {
    $(this.el).html( Mustache.to_html(this.tmpl, this.model.toJSON()) );
    $('#facts_for_channel').append($(this.el));
    return this;
  },

  clickHandler: function(e) {
    document.location.href = this.model.url();
  }
});

ActivityAddedEvidenceView = GenericActivityView.extend({
  initialize: function(options) {
    this.useTemplate("activities", "_added_evidence_activity");
  }
});

ActivityAddedSubchannelView = GenericActivityView.extend({
  initialize: function(options) {
    this.useTemplate("activities", "_added_subchannel_activity");
  }
});
ActivityWasFollowedView = GenericActivityView.extend({});

window.ActivityView = function(opts) {

  switch (opts.model.get("action")) {
    case "added_supporting_evidence":
      return new ActivityAddedEvidenceView(opts);

    case "added_weakening_evidence":
      return new ActivityAddedEvidenceView(opts);

    case "added_subchannel":
      return new ActivityAddedSubchannelView(opts);

    case "was_followed":
      return new ActivityWasFollowedView(opts);

    default:
      return new GenericActivityView(opts);
  }
};
