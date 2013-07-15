class window.AgreeingInteractingUsersView extends Backbone.Marionette.Layout

  className: 'evidence-box interacting-users-box-agree'

  template: 'evidence/interacting_users'

  regions:
    interactingUsersRegion: '.js-region-interacting-users-names'
    interactingUsersAvatarRegion: '.js-region-interacting-users-avatars'

  onRender: ->
    interactors = @collection
    interactors.fetch
      success: => @$('.js-number').html(interactors.impact)

    @interactingUsersRegion.show new NDPInteractorNamesView
      collection: interactors

    @interactingUsersAvatarRegion.show new NDPInteractorsAvatarView
      collection: interactors
