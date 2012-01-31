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

ActivityAddedEvidenceView = GenericActivityView.extend({});
ActivityAddedSubchannelView = GenericActivityView.extend({});
ActivityWasFollowedView = GenericActivityView.extend({});

window.ActivityView = function(opts) {
  if (opts.model.get("action") === "added_evidence") {
    return new ActivityAddedEvidenceView(opts);
  } else if (opts.model.get("action") === "added_subchannel") {
    return new ActivityAddedSubchannelView(opts);
  } else if (opts.model.get("action") === "was_followed") {
    return new ActivityWasFollowedView(opts);
  } else {
    return new GenericActivityView(opts);
  }
};
