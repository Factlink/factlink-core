
# This class whether a certain value is going too fast
# it's too fast if it is larger than speeding. We assume
# that averaging over the last 10 values gives the best
# value for speed
class Factlink.Speedmeter
  constructor: (@speeding)->
    @last_measurements = [[0,0],[0,0],[0,0],[0.0],[0.0]]

  measure: (value) ->
    current_time = new Date().getTime()

    [last_time, last_value] = @last_measurements.shift()

    @speed = Math.abs((value - last_value)/(current_time-last_time))

    @last_measurements.push([current_time, value])

  is_fast: => @speed > @speeding
