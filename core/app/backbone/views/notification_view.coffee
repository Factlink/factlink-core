class GenericNotificationView extends Backbone.Marionette.ItemView
  tagName: "li"
  className: "activity"
  template: "notifications/_generic_activity"
  events:
    'click': 'wholeElementClick'

  wholeElementClick: (e) ->
    if url = @model.get('activity').target_url
      e.preventDefault()
      e.stopImmediatePropagation()
      @trigger 'activityActivated'
      Backbone.history.navigate_with_fallback url, true

  onRender: ->
    @$el.addClass "unread"  if @model.get("unread") is true
    @$el.addClass "has-target-url" if @model.get('activity').target_url


  markAsRead: -> @$el.removeClass "unread"

class NotificationAddedEvidenceView extends GenericNotificationView
  template: "notifications/_added_evidence_activity"

class NotificationAddedSubchannelView extends GenericNotificationView
  template: "notifications/_added_subchannel_activity"

class NotificationInvitedView extends GenericNotificationView
  template: "notifications/_invited_activity"

class NotificationCreatedConversationView extends GenericNotificationView
  template: "notifications/_created_conversation"

class NotificationRepliedConversationView extends GenericNotificationView
  template: "notifications/_replied_conversation"

window.NotificationView = (opts) ->
  switch opts.model.get("action")
    when "added_supporting_evidence", "added_weakening_evidence"
      new NotificationAddedEvidenceView(opts)
    when "added_subchannel"
      new NotificationAddedSubchannelView(opts)
    when "invites"
      new NotificationInvitedView(opts)
    when "created_conversation"
      new NotificationCreatedConversationView(opts)
    when "replied_conversation"
      new NotificationRepliedConversationView(opts)
    else
      new GenericNotificationView(opts)
