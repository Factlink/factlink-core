window.getLocalStorage = (str) ->
  if (typeof localStorage is "object" and localStorage isnt null)
    localStorage[str]
