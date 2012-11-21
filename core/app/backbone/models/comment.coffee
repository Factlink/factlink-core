class window.Comment extends Backbone.Model

  templateHelpers: =>
    creator: @creator

  creator: ->
    new User(@get('created_by'))
