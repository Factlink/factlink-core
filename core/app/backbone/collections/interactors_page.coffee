class window.InteractorsPage extends Backbone.Paginator.requestPager
  model: User,
  server_api:
    take: -> @perPage
    skip: -> (@currentPage-1) * @perPage

  parse: (response) ->
    @totalRecords = response.total
    @impact = response.impact
    @totalPages = Math.floor(response.total / @perPage)
    response.users

  initialize: (models, options) ->
    @type = options.type

    fact_id = options.fact_id
    @paginator_core =
      dataType: "json"
      url: "/facts/#{fact_id}/interactors/#{@type}s"
    @paginator_ui =
      perPage: options.perPage || 6
      firstPage: 1
      currentPage: 1
