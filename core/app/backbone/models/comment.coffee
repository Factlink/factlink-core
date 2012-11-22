class window.Comment extends Backbone.Model

  templateHelpers: =>
    creator: @creator

  creator: -> @user ?= new User(@get('created_by'))
