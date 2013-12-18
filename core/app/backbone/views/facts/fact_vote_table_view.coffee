class window.FactVoteTableView extends Backbone.Marionette.Layout
  tagName: 'table'
  className: 'fact-vote-table'
  template:
    text: """
        <tr>
          <td class="fact-vote-table-cell-believes js-cell-believes"><button class="button js-button-believes"><span class="icon-ok fact-vote-table-active-icon"></span> Agree</button> <span class="js-avatars-believes-region"></span></td>
          <td class="fact-vote-table-cell-doubts js-cell-doubts"><button class="button js-button-doubts"><span class="icon-ok fact-vote-table-active-icon"></span> Unsure</button> <span class="js-avatars-doubts-region"></span></td>
          <td class="fact-vote-table-cell-disbelieves js-cell-disbelieves"><button class="button js-button-disbelieves"><span class="icon-ok fact-vote-table-active-icon"></span> Disagree</button> <span class="js-avatars-disbelieves-region"></span></td>
        </tr>
    """

  regions:
    avatarsBelievesRegion: '.js-avatars-believes-region'
    avatarsDoubtsRegion: '.js-avatars-doubts-region'
    avatarsDisbelievesRegion: '.js-avatars-disbelieves-region'

  events:
    'click .js-button-believes': -> @_votes.saveCurrentUserOpinion 'believes'
    'click .js-button-doubts': -> @_votes.saveCurrentUserOpinion 'doubts'
    'click .js-button-disbelieves': -> @_votes.saveCurrentUserOpinion 'disbelieves'

  initialize: ->
    @_votes = @model.getFactVotes()
    @listenTo @_votes, 'change:current_user_opinion', @_updateActiveCell
    @listenTo @_votes, 'sync', -> @_opinionatorsCollection.fetch()

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
    opinion = @_votes.get('current_user_opinion')
    @$('.fact-vote-table-cell-active').removeClass 'fact-vote-table-cell-active'
    @$(".js-cell-#{opinion}").addClass 'fact-vote-table-cell-active'
