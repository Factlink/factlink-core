#= require './evidence'

class window.Comment extends Evidence

  defaults:
    evidence_type: 'Comment'
    current_user_opinion: "believes"
    sub_comments_count: 0

  validate: (attributes) ->
    'Content should not be empty' unless /^.*\S.*$/.test(attributes.content)

  templateHelpers: =>
    creator: @creator

  creator: -> new User(@get('created_by'))

  can_destroy: -> @get 'can_destroy?'

  believe: -> @save opinion: 'believes'
  disbelieve: -> @save opinion: 'disbelieves'

  isBelieving: -> @get('current_user_opinion') == 'believes'
  isDisBelieving: -> @get('current_user_opinion') == 'disbelieves'

  removeOpinion: -> @unset('opinion'); @save()

  urlRoot: -> @collection.commentsUrl()
