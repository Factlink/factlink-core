class window.AgreeingInteractingUsersView extends Backbone.Marionette.Layout

  className: 'evidence-box interacting-users-box-agree'

  template: 'evidence/interacting_users'

  regions:
    interactingUsersRegion: '.js-region-interacting-users-names'
    interactingUsersAvatarRegion: '.js-region-interacting-users-avatars'

  onRender: ->
    interactors = @model.opinionaters()
    interactors.fetch
      success: =>
        impact = format_as_authority interactors.impact
        @$('.js-number').html impact

    @interactingUsersRegion.show new NDPInteractorNamesView
      model: @model

    @interactingUsersAvatarRegion.show new NDPInteractorsAvatarView
      model: @model
