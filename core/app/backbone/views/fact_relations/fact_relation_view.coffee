#= require ../facts/fact_base_view

class window.FactRelationView extends Backbone.Marionette.Layout
  className: 'fact-relation-body'
  template:  'fact_relations/fact_relation'

  regions:
    factBaseView: '.fact-base-region'

  templateHelpers: =>
    creator: @model.creator().toJSON()

  onRender: ->
    @factBaseView.show @_factBaseView()

  _factBaseView: ->
    fact = @model.getFact()

    fbv = new FactBaseView
      model: fact
      clickable_body: Factlink.Global.signed_in

    @listenTo fact.getFactWheel(), 'sync', ->
      @model.fetch()

    if Factlink.Global.signed_in
      @listenTo fbv, 'click:body', (e) ->
        @defaultClickHandler e, @model.getFact().friendlyUrl()

    fbv

class window.FactRelationEvidenceView extends EvidenceBaseView
  mainView: FactRelationView
  voteView: VoteUpDownView
  delete_message: 'Remove this Factlink as evidence'
