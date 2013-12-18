class window.FactVoteView extends Backbone.Marionette.Layout
  template:
    text: """
      <div class="discussion-evidenceish discussion-evidenceish-box">
        <div class="discussion-evidenceish-content">
          <div>Agrees: <div class="js-avatars-believes-region"></div></div>
          <div>Unsure: <div class="js-avatars-doubts-region"></div></div>
          <div>Disagrees: <div class="js-avatars-disbelieves-region"></div></div>
        </div>
      </div>
    """

  regions:
    avatarsBelievesRegion: '.js-avatars-believes-region'
    avatarsDoubtsRegion: '.js-avatars-doubts-region'
    avatarsDisbelievesRegion: '.js-avatars-disbelieves-region'

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
