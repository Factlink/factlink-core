#= require ../facts/fact_base_view

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

class window.FactRelationEvidenceView extends EvidenceBaseView
  activityVerb: 'added'
  mainView: FactRelationView
  delete_message: 'Remove this Factlink as evidence'
