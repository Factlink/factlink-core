class window.FactRelationsView extends Backbone.Marionette.Layout
  className: "tab-content"
  template: "fact_relations/fact_relations"

  regions:
    interactingUserRegion: '.js-interacting-users-region'
    factRelationsRegion: '.js-fact-relations-region'
    factRelationSearchRegion: '.js-fact-relation-search-region'

  onRender: ->
    @$el.addClass @model.type()

    @interactingUserRegion.show new InteractingUsersNamesView
      collection: @model.getInteractorsEvidence().opinionaters()

    if @model.type() == 'supporting' or @model.type() == 'weakening'
      @model.evidence()?.fetch()

      if Factlink.Global.signed_in
        @factRelationSearchRegion.show new AddEvidenceFormView
          collection: @model.evidence()
          fact_id: @model.fact().id
          type: @model.type()
    else
      @hideRegion @factRelationSearchRegion
      @hideRegion @factRelationsRegion

  hideRegion: (region)-> @$(region.el).hide()
