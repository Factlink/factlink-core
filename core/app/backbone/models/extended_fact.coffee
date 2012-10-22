#= require ./fact
class window.ExtendedFact extends Fact
  urlRoot: '/facts/'

  getFactWheel: () -> @get('fact_wheel')