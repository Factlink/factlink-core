class GenericNotificationView extends Backbone.Marionette.Layout
  tagName: "li"
  className: "activity"
  template: "notifications/generic"
  templateHelpers: ->
    user: (new User @model.get('user')).toJSON()

  events:
    'click a': 'click'

  initialEvents: -> false # stop layout from refreshing after model/collection update
                  # no longer needed in marionette 1.0

  click: (e) ->
    @trigger 'activityActivated'
    return Backbone.View.prototype.defaultClickHandler(e)

  onRender: ->
    @$el.addClass "unread" if @model.get("unread") is true

  markAsRead: -> @$el.removeClass "unread"

class NotificationAddedEvidenceView extends GenericNotificationView
  template: "notifications/added_evidence"

class NotificationAddedSubchannelView extends GenericNotificationView
  template: "notifications/added_subchannel"

  regions:
    addBackRegion: ".js-region-add-back"

  initialize: ->
    @activity = @model.get('activity')

  other_channel: ->
    new Channel
      id: @activity.to_channel_id
      containing_channel_ids: @activity.to_channel_containing_channel_ids

  onRender: ->
    super()

    # TODO clean this behaviour.
    # We don't want Topics with duplicate slug in the SuggestedTopics collection
    topic1 = @channel_as_topic()
    topic2 = @other_channel_as_topic()

    same_slug_title = topic1.get('slug_title') == topic2.get('slug_title')

    topics = [topic1]
    topics.push(topic2) unless same_slug_title
    # end

    suggested_topics = new SuggestedTopics topics
    @addBackRegion.show new AddChannelToChannelsButtonView
                                model: @other_channel()
                                suggested_topics: suggested_topics



class NotificationInvitedView extends GenericNotificationView
  template: "notifications/invited"

class NotificationCreatedConversationView extends GenericNotificationView
  template: "notifications/created_conversation"

class NotificationRepliedMessageView extends GenericNotificationView
  template: "notifications/replied_message"

class CreatedCommentView extends GenericNotificationView
  template: "notifications/created_comment"

window.NotificationView = (opts) ->
  switch opts.model.get("action")
    when "created_comment", "created_sub_comment"
      new CreatedCommentView(opts)
    when "added_supporting_evidence", "added_weakening_evidence"
      new NotificationAddedEvidenceView(opts)
    when "added_subchannel"
      new NotificationAddedSubchannelView(opts)
    when "invites"
      new NotificationInvitedView(opts)
    when "created_conversation"
      new NotificationCreatedConversationView(opts)
    when "replied_message"
      new NotificationRepliedMessageView(opts)
    else
      new GenericNotificationView(opts)
