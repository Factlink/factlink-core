class window.Message extends Backbone.Model
  sender: => new User(@get('sender'))
