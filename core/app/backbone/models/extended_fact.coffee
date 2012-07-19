#= require ./fact
class window.ExtendedFact extends Fact
  url: () -> '/facts/' + @get('id')

  getFactWheel: () -> @get('fact_wheel')