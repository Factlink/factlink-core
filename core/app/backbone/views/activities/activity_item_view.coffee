class GenericActivityItemView extends Backbone.Marionette.ItemView
  template: "activities/generic_activity"
  append: (model) -> false

class CreatedChannelView extends GenericActivityItemView
  template: "activities/created_channel"

class AddedSubchannelView extends GenericActivityItemView
  template: "activities/added_subchannel"

class AddedEvidenceView extends GenericActivityItemView
  template: "activities/added_evidence"

class CreatedCommentView extends GenericActivityItemView
  template: "activities/created_comment"

class AddedOpinionView extends GenericActivityItemView
  template: "activities/added_opinion"

class AddedFactToChannelView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template:
    text: """
      <a rel="backbone" href="{{ activity.channel_url }}">{{ activity.channel_title }}</a>
    """

  appendSeparator: (text)-> @$el.append text

class AddedFactToChannelGroupView extends Backbone.Marionette.CompositeView
  itemView: AddedFactToChannelView
  itemViewContainer: '.js-region-channels'

  template:
    text: """
      <span class="activity-description">{{activity.posted}} to <span class="js-region-channels"></span></span>
    """

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
    if correct_action = model.get('action') in ["added_fact_to_channel"]
      @collection.add model
      true
    else false

class AddedFirstFactlinkView extends GenericActivityItemView
  template: "activities/added_first_factlink"

window.getActivityItemViewFor = (model) ->
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
      GenericActivityItemView
