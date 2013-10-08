FactlinkApp.module "FacebookRenewal", (FacebookRenewal, FactlinkApp, Backbone, Marionette, $, _) ->

  class IframeView extends Backbone.Marionette.ItemView
    template:
      text: """
        <iframe src="/auth/facebook"></iframe>
      """

  FacebookRenewal.addInitializer ->
    if currentUser?.get('services')['facebook']
      checkRenewal()
      currentUser.on 'change', checkRenewal

  timeout     = null
  justRenewed = false

  almostExpired = ->
    days         = 24*60*60*1000
    expiresAt    = currentUser.get('services')['facebook_expires_at']
    expiryDate   = new Date(expiresAt*1000)
    timeToExpiry = expiryDate - new Date

    not justRenewed and timeToExpiry < 14*days

  tryRenewal = ->
    return if timeout
    FactlinkApp.facebookRenewalRegion.show new IframeView
    timeout = setTimeout tryManualRenewal, 10000

  tryManualRenewal = ->
    justRenewed = true
    FactlinkApp.NotificationCenter.error """
      Your Facebook connection could not be automatically verified. Please verify manually.
      <a href="/auth/facebook"
         target="_blank"
         class="button js-social-popup-link js-close" data-disable-with="" data-width="640" data-height="400">
           Verify
      </a>
    """

  checkRenewal = ->
    tryRenewal() if almostExpired()

  FacebookRenewal.success = ->
    clearTimeout timeout
    timeout      = null
    justRenewed  = true
    currentUser.fetch()
