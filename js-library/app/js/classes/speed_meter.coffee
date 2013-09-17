# This class determines whether a certain value is moving too fast
#
# Too fast is defined as larger than speeding.
#
# We assume that averaging over the last few values gives the best
# value for speed (to allow for slow-changing discrete values, which
# would otherwise spike a lot)
class Factlink.Speedmeter
  constructor: (@options)->

  measure:  =>
    @value = @options.get_measure()
    @time = new Date().getTime()

  is_fast: => @speed > @options.speeding

  evaluate_current_state: =>
    last_time = @time
    last_value = @value
    @measure()
    current_speed = Math.abs((@value - last_value)/(@time-last_time))
    @speed = 0.4 * current_speed +
             0.6 * @speed
    @options.on_change()


  remeasure: =>
    @remeasure_timeout ?= setTimeout =>
      @remeasure_timeout = null
      @evaluate_current_state()
      if @speed > @options.speeding
        @remeasure()
    , 100

  start_measuring: =>
    return if @remeasure_timeout
    @speed = @options.speeding
    @measure()
    @remeasure()

