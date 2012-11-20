class window.FactRelation extends Backbone.Model
  setOpinion: (type) ->
    $.ajax
      url: @url() + "/opinion/" + type
      success: (data) =>
        mp_track "Evidence: opinionate",
          type: type
          evidence_id: @id

        @set data

      type: "post"

  believe: -> @setOpinion "believes"
  disbelieve: -> @setOpinion "disbelieves"

  url: ->
    evidence_type = "weakening_evidence"
    evidence_type = "supporting_evidence"  if @get("fact_relation_type") is "believing"
    @collection.fact.url() + "/" + evidence_type + "/" + @get("id")
