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

  urlRoot: -> @collection.commentsUrl()

  argumentVotes: ->
    @_argumentVotes ?= new ArgumentVotes @get('argument_votes'),
      argument: this
