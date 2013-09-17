# This class determines whether a certain value is moving too fast
class Factlink.Speedmeter
  constructor: (@options)->
    unless @options.on_change
      throw "Method for handling speed changes missing"
    unless @options.is_fast_treshold
      throw "Treshold for when to consider speed fast is missing"
    unless @options.get_measure
      throw "Function to measure with mising"

  measure:  =>
    @value = @options.get_measure()
    @time = new Date().getTime()

  determine_speed: =>
    last_time = @time
    last_value = @value
    @measure()
    current_speed = Math.abs((@value - last_value)/(@time-last_time))
    @speed = @smooth_with_last_speed(current_speed)
    @is_fast = @speed > @options.is_fast_treshold

  # This smoothes the new measurement with the previous measurement
  # this way we prevent that a small period of slow scrolling breaks
  # a long period of fast scrolling, resulting in a sudden highlight
  smooth_with_last_speed: (new_speed) =>
     0.4 * new_speed + 0.6 * @speed # multipliers are semi-arbitrary

  remeasure: =>
    @remeasure_timeout ?= setTimeout =>
      @remeasure_timeout = null
      @determine_speed()
      @options.on_change(@is_fast)
      if @is_fast
        @remeasure()
    , 100

  on_possible_speed_change: =>
    return if @remeasure_timeout
    # needed for smoothing, ensures low-latency first measurement
    @speed = @options.is_fast_treshold
    @measure()
    @remeasure()

