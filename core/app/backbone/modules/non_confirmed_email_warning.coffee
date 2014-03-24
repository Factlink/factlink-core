FactlinkApp.module "NonConfirmedEmailWarning", (NonConfirmedEmailWarning, FactlinkApp, Backbone, Marionette, $, _) ->

  checkConfirmedEmail = ->
    return unless FactlinkApp.signedIn()
    return if session.user().get('confirmed')
    return if session.user().justCreated()

    FactlinkApp.NotificationCenter.error """
      Your email address has not yet been confirmed, please check your email inbox.
      <a href="/users/confirmation/new" target="_blank" class="js-close">
        Resend email.
      </a>
    """

  NonConfirmedEmailWarning.addInitializer ->
    checkConfirmedEmail()
    session.user().on 'change', checkConfirmedEmail
