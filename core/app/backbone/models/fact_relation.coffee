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
    evidence_type = "supporting_evidence" if @get("fact_relation_type") is "supporting"
    url = @collection.fact.url() + "/" + evidence_type
    url += "/" + @id if @id?
    url

  creator: -> new User(@get('created_by'))

  can_destroy: -> @creator().get('id') == currentUser.get('id')
