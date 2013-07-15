window.format_as_authority = (number) ->
  if number < 10
    number = parseFloat(number).toFixed(1)
  else if number >= 1000
    "" + Math.floor(number/1000) + "k"
  else
    "#{number}"
