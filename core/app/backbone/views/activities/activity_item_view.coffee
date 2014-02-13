class window.CreatedCommentView extends Backbone.Marionette.ItemView
  template: "activities/created_comment"

class window.FollowedUserView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'separator-list-item'
  template: "activities/followed_user"
  templateHelpers: =>
    followed_user: @user().toJSON()

  user: -> @_user ?= new User(@model.get('activity').followed_user)
