class window.FactBelieversPage extends window.BaseFactInteractorsPage
  initialize: (opts) ->
    fact = opts.fact;
    @paginator_core.url = "/facts/#{fact.id}/believers"

  type : 'supporting'


class window.NDPFactBelieversPage extends window.BaseFactInteractorsPage2
  initialize: (opts) ->
    fact = opts.fact;
    @paginator_core.url = "/facts/#{fact.id}/believers"

  type : 'supporting'
