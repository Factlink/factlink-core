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

class AddedFactToChannelView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: 'activities/added_fact_to_channel'

  appendSeparator: (text)-> @$el.append text

class AddedFactToChannelGroupView extends Backbone.Marionette.CompositeView
  template: 'activities/added_fact_to_channel_group'
  itemView: AddedFactToChannelView
  itemViewContainer: '.js-region-channels'

  initialize: ->
    @collection = new Backbone.Collection [@model]

  initialEvents: ->
    @bindTo @collection, "add remove reset", @render, @

  insertItemSeparator: (itemView, index) ->
    sep = Backbone.Factlink.listSeparator(@collection.length, @collection.length, index)
    itemView.appendSeparator(sep) if sep?

  appendHtml: (collectionView, itemView, index) =>
    @insertItemSeparator itemView, index
    super(collectionView, itemView, index)

  append: (model) ->
    if correct_action = model.get('action') == "added_fact_to_channel"
      @collection.add model
      true
    else false

class AddedFirstFactlinkView extends ActivityItemView
  template: "activities/added_first_factlink"
