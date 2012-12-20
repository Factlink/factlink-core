class window.Comment extends Backbone.Model

  templateHelpers: =>
    creator: @creator

  creator: -> new User(@get('created_by'))

  can_destroy: -> @get 'can_destroy?'

  believe: -> @save opinion: 'believes'
  disbelieve: -> @save opinion: 'disbelieves'

  isBelieving: -> @get('current_user_opinion') == 'believes'
  isDisBelieving: -> @get('current_user_opinion') == 'disbelieves'

  removeOpinion: -> @unset('opinion'); @save()
