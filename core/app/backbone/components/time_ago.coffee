window.TimeAgo = React.createClass
  mixins: [SetIntervalMixin]

  getInitialState: ->
    now: Date.now()

  componentDidMount: ->
    @setInterval(@update_time, 1000)

  update_time: ->
    @setState now: Date.now()

  seconds_lapsed: ->
    (@state.now - Date.parse(@props.time)) / 1000

  showNr: (nr, unit) ->
    "#{Math.round(nr)}#{unit}"

  displayTime: (time) ->
    seconds = 1
    minutes = 60
    hours   = 60 * minutes
    days    = 24 * hours
    months  = 30* days
    years   = 365 * days
    if not time
      '?'
    else if time < 1 * minutes
      "now"
    else if time < 1*hours
      @showNr(time / minutes, 'm')
    else if time < 1*days
      @showNr(time / hours, 'h')
    else if time < 1*months
      @showNr(time / days , 'd')
    else if time < 1*years
      @showNr(time / months, 'mon')
    else
      @showNr(time / years, 'yr')

  render: ->
    span = _span {}, @displayTime(@seconds_lapsed())
    @transferPropsTo span
