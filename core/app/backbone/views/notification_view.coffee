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

class NotificationUserFollowedUser extends NotificationView
  template: "notifications/user_followed_user"

  regions:
    addBackRegion: ".js-region-add-back"

  onRender: ->
    super()
    user = new User(@model.get('user'))
    @addBackRegion.show new FollowUserButtonView(user: user, mini: true)

class NotificationCreatedCommentView extends NotificationView
  template: "notifications/created_comment"

class NotificationCreatedSubCommentView extends NotificationView
  template: "notifications/created_sub_comment"

window.NotificationView = (opts) ->
  switch opts.model.get("action")
    when "created_sub_comment"
      new NotificationCreatedSubCommentView(opts)
    when "created_comment"
      new NotificationCreatedCommentView(opts)
    when "followed_user"
      new NotificationUserFollowedUser(opts)
    else
      throw new Error 'Unknown notification action: ' + opts.model.get("action")
