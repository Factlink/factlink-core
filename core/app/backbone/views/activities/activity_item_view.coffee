class window.ActivityItemView extends Backbone.Marionette.ItemView
  tryAppend: (model) -> false

  @classForModel: (model) ->
    switch model.get("action")
      when "created_comment", "created_fact_relation"
        CreatedFactRelationView
      when "created_sub_comment"
        CreatedSubCommentView
      when "believes", "doubts", "disbelieves"
        AddedOpinionView
      when "added_fact_to_channel" # TODO: rename actual activity to added_fact_to_topic
        AddedFactToTopicGroupView
      when 'followed_user'
        FollowedUserView
      else
        throw 'Unknown activity action: ' + model.get("action")


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
      when "believes"
        Factlink.Global.t.fact_disbelieve_past_singular_action_about
      when "believes"
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

class AddedFactToTopicView extends ActivityItemView
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  tagName: 'span'
  className: 'separator-list-item'
  template: 'activities/added_fact_to_topic'

  templateHelpers: ->
    topic: @topic().toJSON()

  onRender: ->
    Backbone.Factlink.makeTooltipForView @,
      positioning: {align: 'left', side: 'bottom'}
      selector: '.js-link'
      $offsetParent: @options.$offsetParent
      stayWhenHoveringTooltip: true
      hoverIntent: true
      tooltipViewFactory: => new TopicPopoverContentView model: @topic()

  topic: -> @_topic ?= new Topic(@model.get('activity').topic)

class AddedFactToTopicGroupView extends ActivitiesGroupView
  template: 'activities/added_fact_to_topic_group'
  className: ''
  itemView: AddedFactToTopicView
  itemViewContainer: '.js-region-channels'

  itemViewOptions: ->
    $offsetParent: @options.$offsetParent

  actions: -> ["added_fact_to_channel"]
