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

  evaluate_current_state: =>
    last_time = @time
    last_value = @value
    @measure()
    current_speed = Math.abs((@value - last_value)/(@time-last_time))
    @speed = @smooth_with_last_speed(current_speed)
    @is_fast = @speed > @options.speeding
    @options.on_change(@is_fast)

  # This smoothes the new measurement with the previous measurement
  # this way we prevent that a small period of slow scrolling breaks
  # a long period of fast scrolling, resulting in a sudden highlight
  smooth_with_last_speed: (new_speed) =>
     0.4 * new_speed + 0.6 * @speed # multipliers are semi-arbitrary

  remeasure: =>
    @remeasure_timeout ?= setTimeout =>
      @remeasure_timeout = null
      @evaluate_current_state()
      if @is_fast
        @remeasure()
    , 100

  start_measuring: =>
    return if @remeasure_timeout
    # needed for smoothing, ensures low-latency first measurement
    @speed = @options.speeding
    @measure()
    @remeasure()

