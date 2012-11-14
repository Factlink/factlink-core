class window.BaseFactInteractorsPage extends Backbone.Paginator.requestPager
  model: Interaction,
  server_api:
    take: -> @perPage
    skip: -> (@currentPage-1) * @perPage

  paginator_core:
    dataType: "json"

  paginator_ui:
    perPage: 3

  get_total: @total

  parse: (response) ->
    @total = response.total
    console.log('total' : response.total)
    @totalPages = Math.floor(response.total / @perPage)
    response.users
