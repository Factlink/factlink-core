class window.FactVoteView extends Backbone.Marionette.Layout
  template:
    text: """
      <div class="discussion-evidenceish discussion-evidenceish-box">
        <div class="discussion-evidenceish-content">
          <div><button class="button js-button-believes">Agree <span class="opinion_indicator agreeing"> </button> <div class="js-avatars-believes-region"></div></div>
          <div><button class="button js-button-doubts">Unsure <span class="opinion_indicator unsure"> </button> <div class="js-avatars-doubts-region"></div></div>
          <div><button class="button js-button-disbelieves">Disagree <span class="opinion_indicator disagreeing"> </button> <div class="js-avatars-disbelieves-region"></div></div>
        </div>
      </div>
    """

  regions:
    avatarsBelievesRegion: '.js-avatars-believes-region'
    avatarsDoubtsRegion: '.js-avatars-doubts-region'
    avatarsDisbelievesRegion: '.js-avatars-disbelieves-region'

  events:
    'click .js-button-believes': -> @_votes.saveCurrentUserOpinion 'believes'
    'click .js-button-doubts': -> @_votes.saveCurrentUserOpinion 'doubts'
    'click .js-button-disbelieves': -> @_votes.saveCurrentUserOpinion 'disbelieves'

  onRender: ->
    opinionatersCollection = new OpinionatersCollection [
      new OpinionatersEvidence(type: 'believes')
      new OpinionatersEvidence(type: 'disbelieves')
      new OpinionatersEvidence(type: 'doubts')
    ], fact: @model
    opinionatersCollection.fetch()

    @avatarsBelievesRegion.show new InteractingUsersAvatarsView
      collection: opinionatersCollection.get('believes').opinionaters()
    @avatarsDisbelievesRegion.show new InteractingUsersAvatarsView
      collection: opinionatersCollection.get('disbelieves').opinionaters()
    @avatarsDoubtsRegion.show new InteractingUsersAvatarsView
      collection: opinionatersCollection.get('doubts').opinionaters()

    @_votes = @model.getFactVotes()
    @listenTo @_votes, 'change:current_user_opinion', @_updateActiveButton
    @_updateActiveButton()

  _updateActiveButton: ->
    @$('button').removeClass 'button-success button-confirm button-danger'

    switch @_votes.get('current_user_opinion')
      when 'believes'
        @$('.js-button-believes').addClass 'button-success'
      when 'doubts'
        @$('.js-button-doubts').addClass 'button-confirm'
      when 'disbelieves'
        @$('.js-button-disbelieves').addClass 'button-danger'
