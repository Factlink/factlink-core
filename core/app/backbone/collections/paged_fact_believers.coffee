class window.PagedFactBelievers extends Backbone.Paginator.requestPager
  model: Interaction,

  initialize: (opts) ->
    @fact = opts.fact;
    @paginator_core.url = "/facts/#{@fact.id}/believers"

  paginator_core:
    dataType: "json"

  paginator_ui:
    perPage: 3

  server_api:
    take: -> @perPage
    skip: -> (@currentPage-1) * @perPage

  parse: (response) ->
    @totalPages = Math.floor(response.total / @perPage)
    response.users
