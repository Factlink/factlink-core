String.prototype.capitalize = ->
  if @[0] and @.toUpperCase
    @[0].toUpperCase() + @.slice(1)
