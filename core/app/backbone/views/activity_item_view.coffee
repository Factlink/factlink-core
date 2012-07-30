#= require ./fact_view.js

class GenericActivityItemView extends Backbone.Marionette.ItemView
  tagName: "div"
  template: "activities/_generic_activity"

class CreatedChannelView extends GenericActivityItemView
  template: "activities/_created_channel"

class AddedSubchannelView extends GenericActivityItemView
  template: "activities/_added_subchannel"

class GenericActivityFactItemView extends Backbone.Marionette.CompositeView
  itemView: FactView
  initialize: (opts) ->
    if @model.get('render_fact')
      fact = new Fact(@model.get("activity")["fact"])
      @collection = new Backbone.Collection([ fact ])

class AddedEvidenceView extends GenericActivityFactItemView
  template: "activities/_added_evidence"

class AddedOpinionView extends GenericActivityFactItemView
  template: "activities/_added_opinion"

class AddedFactToChannelView extends GenericActivityFactItemView
  template: "activities/_added_fact_to_channel"

class AddedFirstFactlinkView extends GenericActivityFactItemView
  template: "activities/_added_first_factlink"

window.getActivityItemViewFor = (model) ->
  switch model.get("action")
    when "added_supporting_evidence", "added_weakening_evidence"
      AddedEvidenceView
    when "created_channel"
      CreatedChannelView
    when "added_subchannel"
      AddedSubchannelView
    when "believes", "doubts", "disbelieves"
      AddedOpinionView
    when "added_fact_to_channel"
      AddedFactToChannelView
    when "added_first_factlink"
      AddedFirstFactlinkView
    else
      GenericActivityItemView
