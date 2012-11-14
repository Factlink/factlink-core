class window.FactDisbelieversPage extends window.BaseFactInteractorsPage
  initialize: (opts) ->
    @fact = opts.fact;
    @paginator_core.url = "/facts/#{@fact.id}/disbelievers"
