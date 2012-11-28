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

  getFact: ->
    new Fact(@get('fact_base'))

  believe: -> @setOpinion "believes"
  disbelieve: -> @setOpinion "disbelieves"

  creator: -> new User(@get('created_by'))

  can_destroy: -> @get 'can_destroy?'
