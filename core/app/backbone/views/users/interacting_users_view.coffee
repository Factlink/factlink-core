class window.InteractingUsersView extends Backbone.Marionette.Layout

  template: 'evidence/interacting_users'

  regions:
    interactingUsersRegion: '.js-region-interacting-users-names'
    interactingUsersAvatarRegion: '.js-region-interacting-users-avatars'

  onRender: ->
    interactors = @model.opinionaters()
    interactors.fetch
      success: => @$('.js-number').html(interactors.impact)

    @interactingUsersRegion.show new NDPInteractorNamesView
      model: @model

    @interactingUsersAvatarRegion.show new NDPInteractorsAvatarView
      model: @model
