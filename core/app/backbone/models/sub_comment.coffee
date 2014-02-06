class window.SubComment extends Backbone.Model
  creator: -> new User(@get('created_by'))

  can_destroy: ->
    return false if @isNew()
    FactlinkApp.isCurrentUser @creator()

  validate: (attributes) ->
    'Content should not be empty' unless /\S/.test(attributes.content)

  saveWithState: (attrs, options={}) ->
    @set save_failed: false
    error = =>
      @set save_failed: true
      options.error?()

    @save attrs, _.extend(error: error, options)

  toJSON: ->
    json = super

    _.extend {formatted_content: json.content}, json
