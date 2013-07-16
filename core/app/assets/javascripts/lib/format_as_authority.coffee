window.format_as_authority = (number) ->
  if number < 10
    parseFloat(number).toFixed(1)
  else if number < 1000
    Math.floor(number).toString()
  else
    "" + Math.floor(number/1000) + "k"
