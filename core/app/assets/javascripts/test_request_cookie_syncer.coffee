if window.test_counter && /^(::1|127\.0\.0\.1|localhost)$/.test(window.location.hostname)
  if window.history && !/\?test_counter/.test(window.location.href)
    window.history.replaceState(null, document.title,
      window.location.href.replace(/\?|$/,'?test_counter='+window.test_counter+'&')
      )
  if window.test_counter
    window.addEventListener 'unload', -> #phantomjs doesn't support beforeunload
      document.cookie = 'test_counter='+window.test_counter+";path=/"
