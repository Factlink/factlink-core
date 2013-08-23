if window.test_counter &&
    /^(::1|127\.0\.0\.1|localhost)$/.test(window.location.hostname)
  window.$.fx.off = true
  $(() -> window.$.support.transition = undefined)
  window.addEventListener 'unload', -> #phantomjs doesn't support beforeunload
    document.cookie = "test_counter=#{window.test_counter};path=/"
