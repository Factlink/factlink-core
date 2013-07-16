group_for_type = (type) ->
  switch type
    when 'doubt' then 'doubters'
    when 'believe' then 'believers'
    when 'disbelieve' then 'disbelievers'
    else throw "group_for_type: Unrecognized type: #{type}"

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

  initialize: (options) ->
    @type = options.type

    fact_id = options.fact_id
    group = group_for_type(@type)
    @paginator_core =
      dataType: "json"
      url: "/facts/#{fact_id}/#{group}"
    @paginator_ui =
      perPage: options.perPage || 6
      firstPage: 1
      currentPage: 1
