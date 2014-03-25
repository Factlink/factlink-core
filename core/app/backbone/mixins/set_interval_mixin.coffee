window.SetIntervalMixin =
  componentWillMount: ->
    this.intervals = []

  setInterval: ->
    this.intervals.push(setInterval.apply(window, arguments));

  componentWillUnmount: ->
    this.intervals.map(clearInterval);
