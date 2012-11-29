class window.Comment extends Backbone.Model

  templateHelpers: =>
    creator: @creator

  creator: -> new User(@get('created_by'))

  can_destroy: -> @creator().get('id') == currentUser.get('id')

  believe: ->
    @set('opinion', 'believes')
    @save()

  disbelieve: ->
    @set('opinion', 'disbelieves')
    @save()
