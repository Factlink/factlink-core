window.GenericActivityView = Backbone.View.extend({
  tagName: "div",
  className: "user-block",

  initialize: function(options) {
    this.useTemplate("activities", "_generic_activity");
  },

  render: function() {
    this.$el.html( Mustache.to_html(this.tmpl, this.model.toJSON()) );
    return this;
  },

  clickHandler: function(e) {
    document.location.href = this.model.url();
  }
});

ActivityAddedEvidenceView = GenericActivityView.extend({});
ActivityAddedSubchannelView = GenericActivityView.extend({});
ActivityWasFollowedView = GenericActivityView.extend({});

window.ActivityView = function(opts) {
  if (opts.model.get("type") === "added_evidence") {
    return new ActivityAddedEvidenceView(opts);
  } else if (opts.model.get("type") === "added_subchannel") {
    return new ActivityAddedSubchannelView(opts);
  } else if (opts.model.get("type") === "was_followed") {
    return new ActivityWasFollowedView(opts);
  } else {
    return new GenericActivityView(opts);
  }
};
