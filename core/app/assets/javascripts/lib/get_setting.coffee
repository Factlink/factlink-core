window.getSetting = (str) ->
  safeLocalStorage?[str]
