#= require utils/string_hash

describe 'window.string_hash', ->
  tests = [
    ["", 0]
    ["asd\n", 4091756]
    ["http://wwww.really.long.url.com/this/is?really=a&long,long,long,long,long,long,LONG&excessive&float-busting=url#that-should-avoid-NaN-Inf", 2763503700]
    ["   supports spaces!     ",  -373075440]
  ]

  for test in tests
    do (test) ->
      it "hashes \"#{test[0]}\" as #{test[1]}", ->
        expect(string_hash(test[0])).eq test[1]
