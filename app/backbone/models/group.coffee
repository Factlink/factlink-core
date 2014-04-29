class window.Group extends Backbone.Model
  urlRoot: "/api/beta/groups"
  defaults:
    groupname: ''


class window.AllGroups extends Backbone.Factlink.Collection
  model: Group

  url: -> '/api/beta/groups'

