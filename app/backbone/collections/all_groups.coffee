class window.AllGroups extends Backbone.Factlink.Collection
  model: Group

  url: -> '/api/beta/groups'
