Backbone.History.prototype.navigate_with_fallback = (url, args...)->
  if Backbone.History.started
    Backbone.history.navigate url, args...
  else
    window.location.assign(url);
