class window.ExtendedFact extends Fact
  url: () -> '/facts/' + @get('id')

  setTitle: (title, options) ->
    @set('fact_title', title, options)

  getTitle: () -> @get('fact_title')