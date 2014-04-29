wrapper_el = document.createElement('div')
stripHtml = (html_string) ->
  if html_string
    wrapper_el.innerHTML = html_string
    wrapper_el.textContent
  else
    null

class window.Comment extends Backbone.Model
  _.extend @prototype, Backbone.Factlink.ModelSaveWithStateMixin
  _.extend @prototype, Backbone.Factlink.ModelJustCreatedMixin

  defaults:
    sub_comments_count: 0

  validate: (attributes) ->
    'Content should not be empty' unless /^.*\S.*$/m.test(attributes.content)

  creator: -> new User(@get('created_by'))

  _is_mine: -> currentSession.isCurrentUser(@creator())
  can_edit: -> @_is_mine()
  can_destroy: -> @_is_mine() && @get('is_deletable')

  sub_comments: ->
    @_sub_comments ?= new SubComments([], parentModel: @)

  argumentTally: ->
    @_commentTally ?= new CommentTally @get('tally'),
      comment: this

  toJSON: ->
    json = super
    defaults = {formatted_content: json.content}

    _.extend defaults, json,
      formatted_impact: format_as_short_number(@get('impact'))

  saveWithFactAndWithState: (attributes, options) ->
    @collection.fact.saveUnlessNew =>
      @saveWithState(attributes, options)

  textContent: ->
    stripHtml(@get('formatted_content')) || @get('content')
