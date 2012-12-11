# We want an event whenever we change the url of
# the page

old_navigate = Backbone.History.prototype.navigate
new_navigate = (fragment, options)->
  FactlinkApp.vent.trigger 'change_url'
  old_navigate.apply @, arguments

Backbone.History.prototype.navigate = new_navigate
