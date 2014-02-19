FactlinkApp.module "NonConfirmedEmailWarning", (NonConfirmedEmailWarning, FactlinkApp, Backbone, Marionette, $, _) ->

  inTour = ->
    try
      return /^\/p\/(tour)/.test(window.top.location.pathname)
    catch # DOMException from window.top if loaded in client
      return false


  checkConfirmedEmail = ->
    return if inTour()
    return unless currentUser? && currentUser.get('id')
    return if currentUser.get('confirmed')
    return if currentUser.justCreated()

    FactlinkApp.NotificationCenter.error """
      Your email address has not yet been confirmed, please check your email inbox.
      <a href="/users/confirmation/new" target="_blank" class="js-close">
        Resend email.
      </a>
    """

  NonConfirmedEmailWarning.addInitializer ->
    checkConfirmedEmail()
    currentUser?.on 'change', checkConfirmedEmail
