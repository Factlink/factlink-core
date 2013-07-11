#= require ../facts/fact_base_view

class window.FactRelationView extends Backbone.Marionette.Layout
  className: 'fact-relation-body'
  template:  'fact_relations/fact_relation'

  regions:
    factBaseView: '.fact-base-region'

  templateHelpers: =>
    creator: @model.creator().toJSON()

  onRender: ->
    @factBaseView.show @_factBaseView()

  _factBaseView: ->
    fact = @model.getFact()

    fbv = new FactBaseView
      model: fact
      clickable_body: Factlink.Global.signed_in

    if Factlink.Global.signed_in
      @bindTo fbv, 'click:body', (e) =>
        @defaultClickHandler e, @model.getFact().friendlyUrl()

    fbv

class VoteUpDownFactRelationView extends VoteUpDownView
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  current_opinion: -> @model.get('current_user_opinion')

  on_up_vote: ->   @open_vote_popup '.supporting', FactRelationVoteUpView
  on_down_vote: -> @open_vote_popup '.weakening', FactRelationVoteDownView

  open_vote_popup: (selector, view_klass) ->
    return if @popoverOpened selector

    @popoverResetAll()
    @popoverAdd selector,
      side: 'right'
      align: 'top'
      fadeTime: 40
      contentView: @bound_popup_view view_klass

  bound_popup_view: (view_klass) ->
    view = new view_klass model: @model

    @bindTo view, 'saved', =>
      @popoverResetAll()

    view

class window.FactRelationEvidenceView extends EvidenceBaseView
  mainView: FactRelationView
  voteView: VoteUpDownFactRelationView
  delete_message: 'Remove this Factlink as evidence'
