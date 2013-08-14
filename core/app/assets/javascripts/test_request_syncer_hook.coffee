if window.Backbone && /^(::1|127\.0\.0\.1|localhost)$/.test(window.location.hostname)
  old_ajax = Backbone.ajax
  Backbone.ajax = (options) ->
    if(arguments.length != 1)
      throw new Error("Factlink's overridden ajax method only supports the
                       1-argument (an options object) style ajax");

    if window.test_counter
      options.url = options.url.replace(/\?|$/,'?test_counter='+window.test_counter+'&')

    old_ajax options


  console.log 'Loaded test_request_syncer_hook'
