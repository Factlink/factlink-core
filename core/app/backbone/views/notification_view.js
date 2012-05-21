(function(){
window.GenericNotificationView = Backbone.View.extend({
  tagName: "li",
  className: "activity",

  tmpl: Template.use("notifications", "_generic_activity"),

  render: function () {
    this.$el.html( this.tmpl.render(this.model.toJSON()) );

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

var NotificationAddedEvidenceView = GenericNotificationView.extend({
  tmpl: Template.use("notifications", "_added_evidence_activity")
});

var NotificationAddedSubchannelView = GenericNotificationView.extend({
  tmpl: Template.use("notifications", "_added_subchannel_activity")
});

var NotificationOpinionatedView = GenericNotificationView.extend({
  tmpl: Template.use("notifications", "_opinionated_activity")
});

var NotificationInvitedView = GenericNotificationView.extend({
  tmpl: Template.use("notifications", "_invited_activity")
});

var NotificationNewChannelView = GenericNotificationView.extend({
  tmpl: Template.use("notifications", "_new_channel_activity")
});

var AddedFactToChannelView = GenericNotificationView.extend({
  tmpl: Template.use('notifications', '_added_fact_to_channel')
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

    case "created_channel":
      return new NotificationNewChannelView(opts);

    case "added_fact_to_channel":
      return new AddedFactToChannelView(opts);

    default:
      return new GenericNotificationView(opts);
  }
};

}());
