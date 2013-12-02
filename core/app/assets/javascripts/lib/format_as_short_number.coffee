window.format_as_short_number = (number) ->
  return '?' unless number?

  if number < 1000
    Math.floor(number).toString()
  else
    "" + Math.floor(number/1000) + "k"
