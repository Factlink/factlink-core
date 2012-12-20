class window.Comment extends Backbone.Model

  templateHelpers: =>
    creator: @creator

  creator: -> new User(@get('created_by'))

  believe: -> @save opinion: 'believes'
  disbelieve: -> @save opinion: 'disbelieves'

  isBelieving: -> @get('current_user_opinion') == 'believes'
  isDisBelieving: -> @get('current_user_opinion') == 'disbelieves'

  removeOpinion: -> @unset('opinion'); @save()
