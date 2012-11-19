class window.FactRelationSearchResultView extends Backbone.Factlink.PlainView
  tagName: "li"
  events:
    click: "createFactRelation"

  template: "facts/fact_relation_search_result"

  createFactRelation: (e) ->
    factRelations = @options.factRelations

    $.ajax
      url: factRelations.url()
      type: "POST"
      data:
        fact_id: factRelations.fact.get("id")
        evidence_id: @model.get("id")

      success: (newFactRelation) =>
        mp_track "Evidence: Create",
          factlink_id: factRelations.fact.id
          evidence_id: @model.get("id")

        factRelations.add new factRelations.model(newFactRelation),
          highlight: true

        @options.parentView.cancelSearch()
