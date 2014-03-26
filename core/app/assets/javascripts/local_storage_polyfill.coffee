"use strict"
try
  # raises exception if security prevents us from using localStorage
  # this happens when the user blocks third party cookies, and tries
  # to load the client
  localStorage.forceLookupInLocalStorage

  window.safeLocalStorage = localStorage
  window.localStorageIsEnabled = true
catch e
  backend = {}
  impl = window.safeLocalStorage = {
    getItem: (key)->
      backend[key]
    setItem: (key, item) ->
      backend[key] = String(item)
    removeItem: (key)->
      delete backend[key]
    key: (i) -> Object.keys(backend)[i]
  }
  Object.defineProperty impl, 'length',
    get:  -> Object.keys(backend).length

  window.localStorageIsEnabled = false


for property, value of csrfDataForLocalStorage
  window.safeLocalStorage[property] = value
