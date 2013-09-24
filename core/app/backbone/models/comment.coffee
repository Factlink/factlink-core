#= require './evidence'

class window.Comment extends Evidence

  defaults:
    evidence_type: 'Comment'
    current_user_opinion: "believes"
    sub_comments_count: 0

  validate: (attributes) ->
    'Content should not be empty' unless /^.*\S.*$/m.test(attributes.content)

  templateHelpers: =>
    creator: @creator

  creator: -> new User(@get('created_by'))

  can_destroy: -> @get 'can_destroy?'

  setOpinion: (type) ->
    @previous_user_opinion = @get('current_user_opinion')

    @save opinion: type

  undoOpinion: ->
    return if @previous_user_opinion == @get('current_user_opinion')

    if @previous_user_opinion?
      @setOpinion @previous_user_opinion
    else
      @removeOpinion()

  believe: -> @setOpinion 'believes'
  disbelieve: -> @setOpinion 'disbelieves'

  current_opinion: -> @get('current_user_opinion')
  isBelieving: -> @get('current_user_opinion') == 'believes'
  isDisBelieving: -> @get('current_user_opinion') == 'disbelieves'

  removeOpinion: -> @unset('opinion'); @save()

  urlRoot: -> @collection.commentsUrl()
