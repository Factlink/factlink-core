class window.SubComment extends Backbone.Model
  creator: -> new User(@get('created_by'))

  can_destroy: -> @creator().id == currentUser.id
