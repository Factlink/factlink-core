#= require ../users/interacting_users_view
class Evidence extends Backbone.Model

class OpinionatersEvidence extends Evidence

  initialize: (opts) ->
    @set type: opts.type
    @set fact_id: opts.fact_id

  opinionaters: ->
    @_opinionaters ?= new NDPInteractorsPage
      fact_id: @get('fact_id')
      type: @get('type')

group_for_type = (type) ->
  switch type
    when 'doubt' then 'doubters'
    when 'believe' then 'believers'
    when 'disbelieve' then 'disbelievers'
    else throw "group_for_type: Unrecognized type: #{type}"

class NDPInteractorsPage extends Backbone.Paginator.requestPager
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

class window.NDPDiscussionView extends Backbone.Marionette.Layout
  tagName: 'section'
  className: 'discussion2'

  template: 'facts/discussion2'

  regions:
    factRegion: '.fact-region'
    evidenceRegion: '.js-region-evidence'

  onRender: ->
    @factRegion.show new TopFactView model: @model

    opinionaters_collection = new Backbone.Collection [
      new OpinionatersEvidence(type: 'believe',    fact_id: @model.id),
      new OpinionatersEvidence(type: 'disbelieve', fact_id: @model.id),
      new OpinionatersEvidence(type: 'doubt',      fact_id: @model.id)
    ]

    @evidenceRegion.show new NDPEvidenceCollectionView
      collection: opinionaters_collection

class NDPEvidenceCollectionView extends Backbone.Marionette.CollectionView
  itemView: AgreeingInteractingUsersView
