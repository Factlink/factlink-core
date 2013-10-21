FactlinkApp.module "NonConfirmedEmailWarning", (NonConfirmedEmailWarning, FactlinkApp, Backbone, Marionette, $, _) ->

  checkConfirmedEmail = ->
    return if FactlinkApp.inTour
    return unless currentUser?
    return if currentUser.get('confirmed')

    FactlinkApp.NotificationCenter.error """
      Your email address has not yet been confirmed, please check your inbox.
      <a href="/users/confirmation/new" target="_blank" class="js-close">
        Resend email.
      </a>
    """

  NonConfirmedEmailWarning.addInitializer ->
    checkConfirmedEmail()
