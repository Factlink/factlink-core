Backbone.Factlink ||= {}

Backbone.Factlink.asyncChecking = (test, func, thisArg=null, timeout=100) ->
  time = 0; dt = 20; interval = null

  checkTest = ->
    if test.call(thisArg)
      window.clearInterval(interval)
      func.call(thisArg)
    else if time >= timeout
      window.clearInterval(interval)
      console.error "asyncChecking timeout: ", test, func, timeout

    time += dt

  interval = window.setInterval(checkTest, dt)
