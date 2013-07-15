class Evidence extends Backbone.Model

class OpinionatersEvidence extends Evidence

  initialize: (opts) ->
    @type = opts.type
    @fact_id = opts.fact_id

  opinionaters: ->
    new NDPInteractorsPage fact_id: @fact_id, type: @type

group_for_type = (type) ->
  switch type
    when 'doubt' then 'doubters'
    when 'believe' then 'believers'
    when 'disbelieve' then 'disbelievers'
    else throw "group_for_type: Unrecognized type: #{type}"


class NDPInteractorsPage extends window.BaseFactInteractorsPage
  paginator_ui:
    perPage: 6
    firstPage: 1
    currentPage: 1

  initialize: (opts) ->
    @paginator_core.url = "/facts/#{opts.fact_id}/#{group_for_type(opts.type)}"

class window.DiscussionView2 extends Backbone.Marionette.Layout
  tagName: 'section'
  className: 'discussion2'

  template: 'facts/discussion2'

  regions:
    factRegion: '.fact-region'
    evidenceRegion: '.js-region-evidence'

  onRender: ->
    @factRegion.show     new TopFactView model: @model

    believers_model = new OpinionatersEvidence
      type: 'believe'
      fact_id: @model.id

    @evidenceRegion.show new AgreeingInteractingUsersView
      collection: believers_model.opinionaters()
