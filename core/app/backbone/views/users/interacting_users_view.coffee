class window.AgreeingInteractingUsersView extends Backbone.Marionette.Layout

  className: 'evidence-box interacting-users-box-agree'

  template: 'evidence/interacting_users'

  regions:
    interactingUsersRegion: '.js-region-interacting-users-names'
    interactingUsersAvatarRegion: '.js-region-interacting-users-avatars'

  # TODO: Move to some model
  getInteractors: ->
    new NDPFactBelieversPage fact: @model

  onRender: ->
    @interactingUsersRegion.show new NDPInteractorNamesView
      collection: @getInteractors()

    @interactingUsersAvatarRegion.show new NDPInteractorsAvatarView
      collection: @getInteractors()

    interactors = @getInteractors()
    interactors.fetch
      success: => @$('.js-number').html(interactors.impact)
