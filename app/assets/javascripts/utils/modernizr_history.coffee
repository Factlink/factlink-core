# Inlined from modernizr
# https://github.com/Modernizr/Modernizr/blob/de9c2c6ae97736247baa13b23adf2e3ad364668d/feature-detects/history.js

history = ->
    # Issue #733
    # The stock browser on Android 2.2 & 2.3 returns positive on history support
    # Unfortunately support is really buggy and there is no clean way to detect
    # these bugs, so we fall back to a user agent sniff :(
    ua = navigator.userAgent;

    # We only want Android 2, stock browser, and not Chrome which identifies
    # itself as 'Mobile Safari' as well
    if ua.indexOf('Android 2') != -1 &&
       ua.indexOf('Mobile Safari') != -1 &&
       ua.indexOf('Chrome') == -1
      false
    else
      # Return the regular check
      window.history && 'pushState' of window.history

window.Modernizr =
  history: history()
