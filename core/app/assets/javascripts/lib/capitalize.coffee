String.prototype.capitalize = () ->
  @replace /(?:^|\s)\S/g, (a) -> a.toUpperCase()