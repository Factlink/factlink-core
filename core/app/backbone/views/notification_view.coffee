class NotificationView extends Backbone.Marionette.Layout
  tagName: "li"
  className: "activity"
  templateHelpers: ->
    user: (new User @model.get('user')).toJSON()

  events:
    'click a': 'click'

  click: (e) ->
    @trigger 'activityActivated'
    return Backbone.View.prototype.defaultClickHandler(e)

  onRender: ->
    @$el.addClass "unread" if @model.get("unread") is true

  markAsRead: -> @$el.removeClass "unread"

class NotificationAddedArgumentView extends NotificationView
  template: "notifications/added_argument"

class NotificationCreatedConversationView extends NotificationView
  template: "notifications/created_conversation"

class NotificationRepliedMessageView extends NotificationView
  template: "notifications/replied_message"

class NotificationUserFollowedUser extends NotificationView
  template: "notifications/user_followed_user"

  regions:
    addBackRegion: ".js-region-add-back"

  onRender: ->
    super()
    user = new User(@model.get('user'))
    @addBackRegion.show new FollowUserButtonView(user: user, mini: true)

class NotificationCreatedSubCommentView extends NotificationView
  template: "notifications/_created_sub_comment"

window.NotificationView = (opts) ->
  switch opts.model.get("action")
    when "created_sub_comment"
      new NotificationCreatedSubCommentView(opts)
    when "created_comment", "created_fact_relation"
      new NotificationAddedArgumentView(opts)
    when "created_conversation"
      new NotificationCreatedConversationView(opts)
    when "replied_message"
      new NotificationRepliedMessageView(opts)
    when "followed_user"
      new NotificationUserFollowedUser(opts)
    else
      throw new Error 'Unknown notification action: ' + opts.model.get("action")
