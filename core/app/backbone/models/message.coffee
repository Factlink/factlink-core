class window.Message extends Backbone.Model
  urlRoot: '/m'
  sender: => new User(@get('sender'))
