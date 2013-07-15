group_for_type = (type) ->
  switch type
    when 'doubt' then 'doubters'
    when 'believe' then 'believers'
    when 'disbelieve' then 'disbelievers'
    else throw "group_for_type: Unrecognized type: #{type}"

class window.NDPInteractorsPage extends Backbone.Paginator.requestPager
  model: Interaction,
  server_api:
    take: -> @perPage
    skip: -> (@currentPage-1) * @perPage

  parse: (response) ->
    @totalRecords = response.total
    @impact = response.impact
    @totalPages = Math.floor(response.total / @perPage)
    response.users

  paginator_ui:
    perPage: 6
    firstPage: 1
    currentPage: 1

  initialize: (opts) ->
    @paginator_core =
      dataType: "json"
      url: "/facts/#{opts.fact_id}/#{group_for_type(opts.type)}"
