class window.Topic extends Backbone.Model

  idAttribute: 'slug_title'

  isActive: -> @collection.isActive(@)

  facts: -> new TopicFacts([], topic: @)

  urlRoot: ->
    '/t' unless @collection?

  favourite: ->
    currentUser.favourite_topics.create @attributes,
      error: (model) =>
        currentUser.favourite_topics.remove model
        @set 'favouritours_count', @get('favouritours_count')-1

    @set 'favouritours_count', @get('favouritours_count')+1
    currentUser.favourite_topics.sort()

  unfavourite: ->
    currentUser.favourite_topics.get(@id).destroy
      error: (model) =>
        currentUser.favourite_topics.add model
        @set 'favouritours_count', @get('favouritours_count')+1

    @set 'favouritours_count', @get('favouritours_count')-1

  toJSON: ->
    _.extend super(),
      link: '/t/' + @get('slug_title')
