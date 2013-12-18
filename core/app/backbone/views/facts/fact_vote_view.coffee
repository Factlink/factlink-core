class window.FactVoteView extends Backbone.Marionette.Layout
  template:
    text: """
      <table>
        <tr>
          <td><button class="button js-button-believes">Agree</button> <span class="js-avatars-believes-region"></span></td>
          <td><button class="button js-button-doubts">Unsure</button> <span class="js-avatars-doubts-region"></span></td>
          <td><button class="button js-button-disbelieves">Disagree</button> <span class="js-avatars-disbelieves-region"></span></td>
        </tr>
      </table>
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
    @listenTo @_votes, 'change:current_user_opinion', @_updateActiveButton
    @listenTo @_votes, 'sync', -> @_opinionatersCollection.fetch()

    @_opinionatersCollection = new OpinionatersCollection [
      new OpinionatersEvidence(type: 'believes')
      new OpinionatersEvidence(type: 'disbelieves')
      new OpinionatersEvidence(type: 'doubts')
    ], fact_id: @model.id
    @_opinionatersCollection.fetch()

  onRender: ->
    @_updateActiveButton()

    @avatarsBelievesRegion.show new InteractingUsersAvatarsView
      collection: @_opinionatersCollection.get('believes').opinionaters()
    @avatarsDisbelievesRegion.show new InteractingUsersAvatarsView
      collection: @_opinionatersCollection.get('disbelieves').opinionaters()
    @avatarsDoubtsRegion.show new InteractingUsersAvatarsView
      collection: @_opinionatersCollection.get('doubts').opinionaters()

  _updateActiveButton: ->
    @$('button').removeClass 'button-success button-confirm button-danger'

    switch @_votes.get('current_user_opinion')
      when 'believes'
        @$('.js-button-believes').addClass 'button-success'
      when 'doubts'
        @$('.js-button-doubts').addClass 'button-confirm'
      when 'disbelieves'
        @$('.js-button-disbelieves').addClass 'button-danger'
