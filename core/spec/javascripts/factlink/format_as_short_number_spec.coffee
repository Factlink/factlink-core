#= require lib/format_as_short_number

describe 'window.format_as_short_number', ->

  tests = [
    [`undefined`, "?"]
    [null, "?"]

    [0,       "0.0"]
    [3.55555, "3.6"]
    [3.52555, "3.5"]
    [10,      "10" ]
    [127.8392, "127"]
    [1000,    "1k" ]
    [3600,    "3k" ]
  ]

  for test in tests
    do (test) ->
      it "formats #{test[0]} as \"#{test[1]}\"", ->
        expect(format_as_short_number(test[0])).eq test[1]
