#= require lib/format_as_authority

describe 'window.format_as_authority', ->

  tests = [
    [0,       "0.0"],
    [3.55555, "3.6"],
    [3.52555, "3.5"],
    [10,      "10" ],
    [127.8392, "127"],
    [1000,    "1k" ],
    [3600,    "3k" ]
  ]

  for test in tests
    do (test) ->
      it "formats #{test[0]} as \"#{test[1]}\"", ->
        expect(format_as_authority(test[0])).eq test[1]
