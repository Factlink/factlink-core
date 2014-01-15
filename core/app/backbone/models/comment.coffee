class window.Comment extends Backbone.Model

  defaults:
    sub_comments_count: 0

  validate: (attributes) ->
    'Content should not be empty' unless /^.*\S.*$/m.test(attributes.content)

  templateHelpers: =>
    creator: @creator

  creator: -> new User(@get('created_by'))

  _is_mine: -> @creator().is_current_user()

  can_destroy: -> @_is_mine() && @get('is_deletable')

  urlRoot: -> @collection.commentsUrl()

  argumentTally: ->
    @_argumentTally ?= new ArgumentTally @get('tally'),
      argument: this

  toJSON: ->
    json = super
    defaults = {formatted_comment_content: json.content}

    _.extend defaults, json,
      formatted_impact: format_as_short_number(@get('impact'))

