#= require ./facts/fact_base_view

class VoteUpDownView extends Backbone.Marionette.ItemView
  className: 'fact-relation-actions'
  template:  'fact_relations/vote_up_down'

  events:
    "click .weakening": "disbelieve"
    "click .supporting": "believe"

  initialize: ->
    @bindTo @model, "change", @render, @

  hideTooltips: ->
    @$(".weakening").tooltip "hide"
    @$(".supporting").tooltip "hide"

  onRender: ->
    @$(".supporting").tooltip
      title: "This is relevant"

    @$(".weakening").tooltip
      title: "This is not relevant"
      placement: "bottom"

  onBeforeClose: ->
    @$(".weakening").tooltip "destroy"
    @$(".supporting").tooltip "destroy"

  disbelieve: ->
    @hideTooltips()
    @model.disbelieve()

  believe: ->
    @hideTooltips()
    @model.believe()



class FactRelationPopoverView extends EvidencePopoverView
  delete_message: 'Remove this Factlink as evidence'



class window.FactRelationEvidenceView extends EvidenceBaseView
  onRender: ->
    @userAvatarRegion.show new EvidenceUserAvatarView model: @model
    @activityRegion.show   new EvidenceActivityView model: @model

    @voteRegion.show new VoteUpDownView model: @model
    @mainRegion.show new FactRelationView model: @model

    if @model.can_destroy()
      @popoverRegion.show new FactRelationPopoverView model: @model

  highlight: ->
    @$el.animate
      'background-color': '#ffffe1'
    ,
      duration: 500
      complete: ->
        $(this).animate
          'background-color': '#ffffff'
        , 2500



class window.FactRelationView extends Backbone.Marionette.Layout
  className: 'fact-relation-body'
  template: 'fact_relations/fact_relation'

  regions:
    factBaseView:             '.fact-base-region'

  templateHelpers: =>
    creator: @model.creator().toJSON()

  onRender: ->
    @factBaseView.show new FactBaseView(model: @model)
