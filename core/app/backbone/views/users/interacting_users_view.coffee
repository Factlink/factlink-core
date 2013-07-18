class window.InteractingUsersView extends Backbone.Marionette.Layout

  className: 'ndp-interacting-users'
  template: 'evidence/interacting_users'

  regions:
    interactingUsersRegion: '.js-region-interacting-users-names'
    interactingUsersAvatarRegion: '.js-region-interacting-users-avatars'

  onRender: ->
    @interactingUsersRegion.show new InteractingUsersNamesView
      model: @model

    @interactingUsersAvatarRegion.show new NDPInteractingUsersAvatarsView
      model: @model
