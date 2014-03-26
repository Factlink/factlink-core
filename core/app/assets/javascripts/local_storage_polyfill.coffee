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

bad_keys = []
for i in [0...safeLocalStorage.length]
  key = safeLocalStorage.key i
  if key.startsWith('add_comment_to_fact_') && !safeLocalStorage.getItem key
    bad_keys.push key

for key in bad_keys
  safeLocalStorage.removeItem key

for property, value of csrfDataForLocalStorage
  window.safeLocalStorage[property] = value
