#= require ../facts/fact_base_view

class FactRelationVoteUpDownView extends VoteUpDownView
  className: 'fact-relation-actions'
  template:  'fact_relations/vote_up_down'



class FactRelationPopoverView extends EvidencePopoverView
  delete_message: 'Remove this Factlink as evidence'



class window.FactRelationEvidenceView extends EvidenceBaseView
  onRender: ->
    @userAvatarRegion.show new EvidenceUserAvatarView model: @model
    @activityRegion.show   new EvidenceActivityView model: @model, verb: 'added'

    @voteRegion.show new FactRelationVoteUpDownView model: @model
    @mainRegion.show new FactRelationView model: @model

    @setPopover FactRelationPopoverView

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
    @factBaseView.show @_factBaseView()

  _factBaseView: ->
    fbv = new FactBaseView(model: @model)

    @bindTo fbv, 'click:body', =>
      Backbone.history.navigate @model.getFact().friendlyUrl(), true

    fbv
