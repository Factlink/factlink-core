class window.Comment extends Backbone.Model

  templateHelpers: =>
    creator: @creator

  creator: -> new User(@get('created_by')).toJSON()

  can_destroy: -> @creator().get('id') == currentUser.get('id')
