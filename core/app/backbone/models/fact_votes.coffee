#TODO: refactoring of this and related files.
# - make unset state explicit.
# - simplify rest api (no need for delete!)
# - pursue these changes into related code.

class window.FactVotes extends Backbone.Model
  defaults:
    believes_count: 0
    disbelieves_count: 0
    doubts_count: 0

  setCurrentUserOpinion: (newValue) ->
    previousValue = @get('current_user_opinion')
    @set "#{previousValue}_count", @get("#{previousValue}_count")-1 if previousValue?
    @set "#{newValue}_count", @get("#{newValue}_count")+1 if newValue?
    @set 'current_user_opinion', newValue

  # TODO: Use @save here!!
  setActiveOpinionType: (opinion_type) ->
    @previous_opinion_type = @get('current_user_opinion')
    fact_id = @get('fact_id')
    @setCurrentUserOpinion opinion_type

    Backbone.sync 'create', this,
      attrs: {}
      url: "/facts/#{fact_id}/opinion/#{opinion_type}.json"
      success: (data, status, response) =>
        mp_track "Factlink: Opinionate",
          factlink: fact_id
          opinion: opinion_type
        @trigger 'sync', this, response # TODO: Remove when using Backbone sync
      error: =>
        # TODO: This is not a proper undo. Should be restored to the current
        #       state when the request fails.
        if @previous_opinion_type
          @setCurrentUserOpinion @previous_opinion_type
        else
          @setCurrentUserOpinion null
        FactlinkApp.NotificationCenter.error "Something went wrong while setting your opinion on the Factlink, please try again."

  # TODO: Use @save here!!
  unsetActiveOpinionType: ->
    @previous_opinion_type = @get('current_user_opinion')
    fact_id = @get('fact_id')
    @setCurrentUserOpinion null

    Backbone.sync 'delete', this,
      attrs: {}
      url: "/facts/#{fact_id}/opinion.json"
      success: (data, status, response) =>
        mp_track "Factlink: De-opinionate",
          factlink: fact_id
        @trigger 'sync', this, response # TODO: Remove when using Backbone sync
      error: =>
        @setCurrentUserOpinion @previous_opinion_type
        FactlinkApp.NotificationCenter.error "Something went wrong while removing your opinion on the Factlink, please try again."

  believe: -> @setActiveOpinionType 'believes'
  disbelieve: -> @setActiveOpinionType 'disbelieves'
  isBelieving: -> @get('current_user_opinion') == 'believes'
  isDisBelieving: -> @get('current_user_opinion') == 'disbelieves'

  totalCount: -> @get('believes_count') + @get('disbelieves_count') + @get('doubts_count')
