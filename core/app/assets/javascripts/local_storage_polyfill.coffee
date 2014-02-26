try
  # raises exception if security prevents us from using localStorage
  # this happens when the user blocks third party cookies, and tries
  # to load the client
  localStorage.forceLookupInLocalStorage

  window.safeLocalStorage = localStorage
  window.localStorageIsEnabled = true
catch e
  window.safeLocalStorage = {
    getItem: (key)->
      @[key]
    setItem: (key, item) ->
      @[key] = item
    removeItem: (key)->
      delete @[key]
  }
  window.localStorageIsEnabled = false

for property, value of csrfDataForLocalStorage
  window.safeLocalStorage[property] = value
