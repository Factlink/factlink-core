class window.ActivityItemView extends Backbone.Marionette.ItemView
  template: "activities/generic_activity"
  tryAppend: (model) -> false

  @classForModel: (model) ->
    switch model.get("action")
      when "added_supporting_evidence", "added_weakening_evidence"
        AddedEvidenceView
      when "created_comment", "created_sub_comment"
        CreatedCommentView
      when "created_channel"
        CreatedChannelView
      when "added_subchannel"
        AddedSubchannelView
      when "believes", "doubts", "disbelieves"
        AddedOpinionView
      when "added_fact_to_channel" # TODO: rename actual activity to added_fact_to_topic
        AddedFactToTopicGroupView
      when 'followed_user'
        FollowedUserView
      when "added_first_factlink"
        AddedFirstFactlinkView
      else
        ActivityItemView

class CreatedChannelView extends ActivityItemView
  template: "activities/created_channel"

class AddedSubchannelView extends ActivityItemView
  template: "activities/added_subchannel"

class AddedEvidenceView extends ActivityItemView
  template: "activities/added_evidence"

class CreatedCommentView extends ActivityItemView
  template: "activities/created_comment"

class AddedOpinionView extends ActivityItemView
  template: "activities/added_opinion"

class FollowedUserView extends ActivityItemView
  tagName: 'span'
  className: 'separator-list-item'
  template: "activities/followed_user"
  templateHelpers: =>
    followed_user: new User(@model.get('activity').followed_user).toJSON()

class AddedFirstFactlinkView extends ActivityItemView
  template: "activities/added_first_factlink"

class AddedFactToTopicView extends ActivityItemView
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  tagName: 'span'
  className: 'separator-list-item'
  template: 'activities/added_fact_to_topic'

  templateHelpers: ->
    topic: @topic().toJSON()

  onRender: ->
    Backbone.Factlink.makeTooltipForView @,
      positioning:
        align: 'left'
        side: 'bottom'
      selector: '.js-link'
      $offsetParent: @options.$offsetParent
      tooltipViewFactory: =>
        new StatisticsPopoverContentView
          model: @topic()
          buttonView: new FavouriteTopicButtonView topic: @topic(), mini: true
          statisticsView: new TopicStatisticsView model: @topic()

  topic: -> @_topic ?= new Topic(@model.get('activity').topic)

class AddedFactToTopicGroupView extends ActivitiesGroupView
  template: 'activities/added_fact_to_topic_group'
  className: ''
  itemView: AddedFactToTopicView
  itemViewContainer: '.js-region-channels'

  collectionEvents:
    'add remove reset': 'render'

  itemViewOptions: ->
    $offsetParent: @options.$offsetParent

  actions: -> ["added_fact_to_channel"]
