FactlinkApp.module "NonConfirmedEmailWarning", (NonConfirmedEmailWarning, FactlinkApp, Backbone, Marionette, $, _) ->

  checkConfirmedEmail = ->
    return unless currentUser?
    return if currentUser.get('confirmed')

    FactlinkApp.NotificationCenter.error """
      Your email address has not yet been confirmed.
    """

  NonConfirmedEmailWarning.addInitializer ->
    checkConfirmedEmail()
