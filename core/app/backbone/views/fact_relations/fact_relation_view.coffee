#= require ../facts/fact_base_view

class window.FactRelationView extends Backbone.Marionette.Layout
  className: 'fact-relation-body'
  template: 'fact_relations/fact_relation'

  regions:
    factBaseView: '.fact-base-region'

  templateHelpers: =>
    showTime: false
    showRepost: false
    showShare: false
    showSubComments: true
    showFactInfo: @model.get('fact_base').scroll_to_link
    creator: @model.creator().toJSON()
    fact_url_host: ->
      new Backbone.Factlink.Url(@fact_url).host() if @fact_url?

  onRender: ->
    @factBaseView.show @_factBaseView()

  _factBaseView: ->
    fbv = new FactBaseView(model: @model)

    @bindTo fbv, 'click:body', (e) =>
      @defaultClickHandler e, @model.getFact().friendlyUrl()

    fbv

class window.FactRelationEvidenceView extends EvidenceBaseView
  activityVerb: 'added'
  mainView: FactRelationView
  delete_message: 'Remove this Factlink as evidence'
