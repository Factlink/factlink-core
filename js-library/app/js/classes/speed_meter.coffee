# This class determines whether a certain value is moving too fast
#
# Too fast is defined as larger than speeding.
#
# We assume that averaging over the last few values gives the best
# value for speed (to allow for slow-changing discrete values, which
# would otherwise spike a lot)
class Factlink.Speedmeter
  constructor: (@speeding, options={})->
    smooth_over = options.smooth_over || 1
    initial_value = options.smooth_over || 0
    @last_measurements = [new Date().getTime(), initial_value] for i in [0..smooth_over]

  measure: (value) ->
    current_time = new Date().getTime()

    [last_time, last_value] = @last_measurements.shift()

    @speed = Math.abs((value - last_value)/(current_time-last_time))

    @last_measurements.push([current_time, value])

  is_fast: => @speed > @speeding
