class window.Topic extends Backbone.Model

  idAttribute: 'slug_title'

  isActive: -> @collection.isActive(@)

  urlRoot: ->
    '/t' unless @collection?

  toJSON: ->
    _.extend super(),
      link: '/t/' + @get('slug_title')
