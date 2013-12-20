#TODO: refactoring of this and related files.
# - make unset state explicit.
# - simplify rest api (no need for delete!)
# - pursue these changes into related code.

class window.FactTally extends Backbone.Model
  defaults:
    believes: 0
    disbelieves: 0
    doubts: 0
    current_user_opinion: 'no_vote'

  initialize: (attributes, options) ->
    @_fact = options.fact

  isNew: -> @_fact.isNew()

  url: -> @_fact.url() + '/opinion'

  _setCurrentUserOpinion: (newValue) ->
    previousValue = @get('current_user_opinion')
    @set previousValue, @get(previousValue)-1 if previousValue != 'no_vote'
    @set newValue, @get(newValue)+1 if newValue != 'no_vote'
    @set 'current_user_opinion', newValue

  _saveCurrentUserOpinion: (opinion_type) ->
    @previous_opinion_type = @get('current_user_opinion')

    @_setCurrentUserOpinion opinion_type
    @save {},
      success: (data, status, response) =>
        mp_track "Factlink: Opinionate", factlink: @get('fact_id'), opinion: opinion_type
      error: =>
        @_setCurrentUserOpinion @previous_opinion_type
        FactlinkApp.NotificationCenter.error "Something went wrong while setting your opinion on the Factlink, please try again."

  clickCurrentUserOpinion: (opinion_type) ->
    if @get('current_user_opinion') == opinion_type
      @_saveCurrentUserOpinion 'no_vote'
    else
      @_saveCurrentUserOpinion opinion_type

  totalCount: -> @get('believes') + @get('disbelieves') + @get('doubts')
