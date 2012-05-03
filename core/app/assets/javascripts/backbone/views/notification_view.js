(function(){
window.GenericNotificationView = Backbone.View.extend({
  tagName: "li",
  className: "activity",

  initialize: function(options) {
    this.useTemplate("notifications", "_generic_activity");
  },

  render: function () {
    this.$el.html(Mustache.to_html(this.tmpl, this.model.toJSON()));

    if ( this.model.get('unread') === true ) {
      this.$el.addClass('unread');
    }

    return this;
  },

  clickHandler: function(e) {
    document.location.href = this.model.url();
  },

  markAsRead: function () {
    this.$el.removeClass('unread');
  }
});

NotificationAddedEvidenceView = GenericNotificationView.extend({
  initialize: function(options) {
    this.useTemplate("notifications", "_added_evidence_activity");
  }
});

NotificationAddedSubchannelView = GenericNotificationView.extend({
  initialize: function(options) {
    this.useTemplate("notifications", "_added_subchannel_activity");
  }
});

NotificationOpinionatedView = GenericNotificationView.extend({
  initialize: function(options) {
    this.useTemplate("notifications", "_opinionated_activity");
  }
});

NotificationInvitedView = GenericNotificationView.extend({
  initialize: function(options) {
    this.useTemplate("notifications", "_invited_activity");
  }
});

window.NotificationView = function(opts) {
  switch (opts.model.get("action")) {
    case "added_supporting_evidence":
    case "added_weakening_evidence":
      return new NotificationAddedEvidenceView(opts);

    case "added_subchannel":
      return new NotificationAddedSubchannelView(opts);

    case "believes":
    case "disbelieves":
    case "doubts":
      return new NotificationOpinionatedView(opts);

    case "invites":
      return new NotificationInvitedView(opts);

    default:
      return new GenericNotificationView(opts);
  }
};

}());