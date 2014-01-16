class window.ActivityItemView extends Backbone.Marionette.ItemView
  tryAppend: (model) -> false

  @classForModel: (model) ->
    switch model.get("action")
      when "created_comment"
        CreatedFactRelationView
      when "created_sub_comment"
        CreatedSubCommentView
      when "believes", "doubts", "disbelieves"
        AddedOpinionView
      when 'followed_user'
        FollowedUserView
      else
        throw new Error 'Unknown activity action: ' + model.get("action")


class CreatedFactRelationView extends ActivityItemView
  template: "activities/created_fact_relation"

class CreatedSubCommentView extends ActivityItemView
  template: "activities/created_sub_comment"

class AddedOpinionView extends ActivityItemView
  template: "activities/added_opinion"
  templateHelpers: =>
    translated_action: @_translatedAction()

  _translatedAction: ->
    switch @model.get('action')
      when "believes"
        Factlink.Global.t.fact_believe_past_singular_action_about
      when "disbelieves"
        Factlink.Global.t.fact_disbelieve_past_singular_action_about
      when "doubts"
        Factlink.Global.t.fact_doubt_past_singular_action_about

class FollowedUserView extends ActivityItemView
  tagName: 'span'
  className: 'separator-list-item'
  template: "activities/followed_user"
  templateHelpers: =>
    followed_user: @user().toJSON()

  onRender: ->
    UserPopoverContentView.makeTooltip @, @user(),
      selector: '.js-activity-user'
      $offsetParent: @options.$offsetParent

  user: -> @_user ?= new User(@model.get('activity').followed_user)
