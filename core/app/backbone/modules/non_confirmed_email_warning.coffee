FactlinkApp.module "NonConfirmedEmailWarning", (NonConfirmedEmailWarning, FactlinkApp, Backbone, Marionette, $, _) ->

  NonConfirmedEmailWarning.addInitializer ->

    if currentUser?.get('should_show_confirmation_alert')
      FactlinkApp.NotificationCenter.error """
        Your email address has not yet been confirmed, please check your inbox.
        <a href="/users/confirmation/new" target="_blank" class="js-close">
          Resend email.
        </a>
      """
