class window.SubComment extends Backbone.Model
  creator: -> new User(@get('created_by'))
