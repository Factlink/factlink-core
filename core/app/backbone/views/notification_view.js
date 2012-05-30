(function(){
var GenericNotificationView = Backbone.Marionette.ItemView.extend({
  tagName: "li",
  className: "activity",

  template: "notifications/_generic_activity",

  onRender: function () {
    if ( this.model.get('unread') === true ) {
      this.$el.addClass('unread');
    }
  },

  clickHandler: function(e) {
    document.location.href = this.model.url();
  },

  markAsRead: function () {
    this.$el.removeClass('unread');
  }
});

var NotificationAddedEvidenceView = GenericNotificationView.extend({
  template: "notifications/_added_evidence_activity"
});

var NotificationAddedSubchannelView = GenericNotificationView.extend({
  template: "notifications/_added_subchannel_activity"
});

var NotificationOpinionatedView = GenericNotificationView.extend({
  template: "notifications/_opinionated_activity"
});

var NotificationInvitedView = GenericNotificationView.extend({
  template: "notifications/_invited_activity"
});

var NotificationNewChannelView = GenericNotificationView.extend({
  template: "notifications/_new_channel_activity"
});

var AddedFactToChannelView = GenericNotificationView.extend({
  template: 'notifications/_added_fact_to_channel'
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
