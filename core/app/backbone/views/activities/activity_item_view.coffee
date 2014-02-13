class window.ActivityItemView extends Backbone.Marionette.ItemView
  tryAppend: (model) -> false

  @for: (options) ->
    switch options.model.get("action")
      when "created_comment"
        new CreatedCommentView
      when "created_sub_comment"
        new CreatedSubCommentView options
      when "believes", "disbelieves", "doubts"
        new AddedOpinionView options
      when 'followed_user'
        new FollowedUserView options
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
