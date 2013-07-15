class window.BaseFactInteractorsPage extends Backbone.Paginator.requestPager
  model: Interaction,
  server_api:
    take: -> @perPage
    skip: -> (@currentPage-1) * @perPage

  paginator_core:
    dataType: "json"

  paginator_ui:
    perPage: 3
    firstPage: 1
    currentPage: 1

  parse: (response) ->
    @totalRecords = response.total
    @totalPages = Math.floor(response.total / @perPage)
    response.users

# TODO: use `perPage: 6` here
class window.BaseFactInteractorsPage2 extends BaseFactInteractorsPage
  paginator_ui:
    perPage: 2
    firstPage: 1
    currentPage: 1
