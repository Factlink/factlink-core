class window.Conversation extends Backbone.Model
  urlRoot: '/m'
  recipients: => new Users(@get('recipients'))
