load_moments = []

add_timing_event = (name) ->
  add_existing_timing_event name, new Date().getTime()

add_existing_timing_event = (name, time) ->
  load_moments.push(Object.freeze(name:name, time: time, idx: load_moments.length))

get_sorted_moments = -> load_moments.sort (x,y) -> x.time - y.time || x.idx - y.idx

get_relative_timings = ->
  sorted_moments = get_sorted_moments()
  sorted_moments.map( (o) -> { name:o.name, offset: o.time - sorted_moments[0].time})

get_perf_summary = ->
  moments = get_relative_timings()

  max = (a,b) -> Math.max(a,b)

  name_col_width = moments.map( (o) -> o.name.length).reduce(max)
  offset_col_width = moments.map( (o) -> ('' + o.offset).length).reduce(max)
  padder = new Array(max(name_col_width,offset_col_width)+1).join(' ')

  moments.map( (o) ->
      (o.name + padder).substr(0,name_col_width) + ' | ' +
      (padder + o.offset).substr(-offset_col_width)
    ).join('\n')

FactlinkJailRoot.core_loaded_promise.then( ->
  if window.performance && window.performance.timing
    'fetchStart responseEnd domLoading domInteractive domContentLoadedEventEnd domComplete loadEventEnd'
      .split(' ').forEach (timing_event) ->
        add_existing_timing_event timing_event, window.performance.timing[timing_event]
).then( ->
  FactlinkJailRoot.delay 1000
).then( ->
  if FactlinkJailRoot.can_haz.log_jslib_loading_performance
    console.log get_perf_summary()
)

FactlinkJailRoot.perf =
  add_timing_event: add_timing_event
  add_existing_timing_event: add_existing_timing_event
  get_sorted_moments: get_sorted_moments
  get_relative_timings: get_relative_timings
  get_perf_summary: get_perf_summary
