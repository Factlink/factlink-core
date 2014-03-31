class window.SubComment extends Backbone.Model
  _.extend @prototype, Backbone.Factlink.ModelSaveWithStateMixin

  creator: -> new User(@get('created_by'))

  can_destroy: ->
    return false if @isNew()
    currentSession.isCurrentUser @creator()

  validate: (attributes) ->
    'Content should not be empty' unless /\S/.test(attributes.content)

  toJSON: ->
    json = super

    _.extend {formatted_content: json.content}, json
