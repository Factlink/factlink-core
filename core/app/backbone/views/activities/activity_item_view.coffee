class window.ActivityItemView extends Backbone.Marionette.ItemView
  tryAppend: (model) -> false

  @classForModel: (model) ->
    switch model.get("action")
      when "created_comment"
        CreatedCommentView
      when "created_sub_comment"
        CreatedSubCommentView
      when "believes", "disbelieves", "doubts"
        AddedOpinionView
      when 'followed_user'
        FollowedUserView
      else
        throw new Error 'Unknown activity action: ' + model.get("action")


class CreatedCommentView extends ActivityItemView
  template: "activities/created_comment"

class CreatedSubCommentView extends ActivityItemView
  template: "activities/created_sub_comment"

actionToIcon =
  believes: 'icon-thumbs-believes'
  disbelieves: 'icon-thumbs-disbelieves'
  doubts: 'icon-meh'

class AddedOpinionView extends ActivityItemView
  template: "activities/added_opinion"
  templateHelpers: =>
    action_icon_class: actionToIcon[@model.get('action')]

class FollowedUserView extends ActivityItemView
  tagName: 'span'
  className: 'separator-list-item'
  template: "activities/followed_user"
  templateHelpers: =>
    followed_user: @user().toJSON()

  user: -> @_user ?= new User(@model.get('activity').followed_user)
