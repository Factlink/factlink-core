class window.FactVoteTableView extends Backbone.Marionette.Layout
  tagName: 'table'
  className: 'fact-vote-table'
  template: 'facts/fact_vote_table'

  regions:
    avatarsBelievesRegion: '.js-avatars-believes-region'
    avatarsDoubtsRegion: '.js-avatars-doubts-region'
    avatarsDisbelievesRegion: '.js-avatars-disbelieves-region'

  events:
    'click .js-button-believes': -> @_tally.clickCurrentUserOpinion 'believes'
    'click .js-button-doubts': -> @_tally.clickCurrentUserOpinion 'doubts'
    'click .js-button-disbelieves': -> @_tally.clickCurrentUserOpinion 'disbelieves'

  initialize: ->
    @_tally = @model.getFactTally()
    @listenTo @_tally, 'change:current_user_opinion', @_updateActiveCell
    @listenTo @_tally, 'sync', -> @_opinionatorsCollection.fetch()

    @_opinionatorsCollection = new OpinionatorsCollection [
      new OpinionatorsEvidence(type: 'believes')
      new OpinionatorsEvidence(type: 'disbelieves')
      new OpinionatorsEvidence(type: 'doubts')
    ], fact_id: @model.id
    @_opinionatorsCollection.fetch()

  onRender: ->
    @_updateActiveCell()

    @avatarsBelievesRegion.show new OpinionatorsAvatarsView
      collection: @_opinionatorsCollection.get('believes').opinionators()
    @avatarsDisbelievesRegion.show new OpinionatorsAvatarsView
      collection: @_opinionatorsCollection.get('disbelieves').opinionators()
    @avatarsDoubtsRegion.show new OpinionatorsAvatarsView
      collection: @_opinionatorsCollection.get('doubts').opinionators()

  _updateActiveCell: ->
    opinion = @_tally.get('current_user_opinion')
    @$('.fact-vote-table-cell-active').removeClass 'fact-vote-table-cell-active'
    @$(".js-cell-#{opinion}").addClass 'fact-vote-table-cell-active'
