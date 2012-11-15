class window.FactDoubtersPage extends window.BaseFactInteractorsPage
  initialize: (opts) ->
    @fact = opts.fact;
    @paginator_core.url = "/facts/#{@fact.id}/doubters"

  type: 'doubting'
