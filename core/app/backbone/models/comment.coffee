class window.Comment extends Backbone.Model
  _.extend @prototype, Backbone.Factlink.ModelSaveWithStateMixin

  defaults:
    sub_comments_count: 0

  validate: (attributes) ->
    'Content should not be empty' unless /^.*\S.*$/m.test(attributes.content)

  creator: -> new User(@get('created_by'))

  _is_mine: -> FactlinkApp.isCurrentUser(@creator())

  can_destroy: -> @_is_mine() && @get('is_deletable')

  sub_comments: ->
    @_sub_comments ?= new SubComments([], parentModel: @)

  argumentTally: ->
    @_argumentTally ?= new ArgumentTally @get('tally'),
      argument: this

  toJSON: ->
    json = super
    defaults = {formatted_content: json.content}

    _.extend defaults, json,
      formatted_impact: format_as_short_number(@get('impact'))

  share: (providers) ->
    @collection.fact.share providers, @get('content')

  # TODO: Save a fact in the backend when submitting a comment
  saveWithFactAndWithState: (attributes, options) ->
    if @collection.fact.isNew()
      @collection.fact.save {},
        success: =>
          @saveWithState(attributes, options)
    else
      @saveWithState(attributes, options)
