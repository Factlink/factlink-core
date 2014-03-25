window.SetIntervalMixin =
  componentWillMount: ->
    this.intervals = []

  #note: IE9 requires setInterval/clearInterval to have this be window
  setInterval: ->
    this.intervals.push(setInterval.apply(window, arguments));

  componentWillUnmount: ->
    this.intervals.map(clearInterval.bind(window));
