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

  removeOpinion: ->
    $.ajax
      url: "#{@url()}/opinion"
      type: "delete"
      success: (data) =>
        @set data

  getFact: ->
    new Fact(@get('fact_base'))

  believe: -> @setOpinion "believes"
  disbelieve: -> @setOpinion "disbelieves"

  isBelieving: -> @get('current_user_opinion') == 'believes'
  isDisBelieving: -> @get('current_user_opinion') == 'disbelieves'

  creator: -> new User(@get('created_by'))
