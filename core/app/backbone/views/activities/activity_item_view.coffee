class window.ActivityItemView extends Backbone.Marionette.ItemView
  template: "activities/generic_activity"
  append: (model) -> false

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
      when "added_fact_to_channel"
        AddedFactToChannelGroupView
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

class AddedFactToChannelView extends ActivityItemView
  tagName: 'span'
  className: 'separator-list-item'
  template: 'activities/added_fact_to_channel'

class AddedFactToChannelGroupView extends UserActivitiesGroupView
  template: 'activities/added_fact_to_channel_group'
  className: ''
  itemView: AddedFactToChannelView
  itemViewContainer: '.js-region-channels'

  actions: -> ["added_fact_to_channel"]

  initialEvents: ->
    @bindTo @collection, "add remove reset", @render, @

class AddedFirstFactlinkView extends ActivityItemView
  template: "activities/added_first_factlink"
