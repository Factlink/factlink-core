FactlinkApp.module "FacebookRenewal", (FacebookRenewal, FactlinkApp, Backbone, Marionette, $, _) ->

  if Factlink.Global.environment == 'test'
    renewal_url = "about:blank"
  else
    renewal_url = "/auth/facebook"

  class IframeView extends Backbone.Marionette.ItemView
    template:
      text: """
        <iframe class="facebook_renewal_iframe" src="#{renewal_url}" style="height: 0; width: 0; border: 0;"></iframe>
      """

  FacebookRenewal.addInitializer ->
    tryRenewal()
    currentUser.on 'change', tryRenewal

  timeout     = null
  justRenewed = false

  almostExpired = ->
    days         = 24*60*60*1000
    expiresAt    = currentUser.get('services')['facebook_expires_at']
    expiryDate   = new Date(expiresAt*1000)
    timeToExpiry = expiryDate - new Date

    not justRenewed and timeToExpiry < 14*days

  tryRenewal = ->
    return unless currentUser.get('services')?['facebook']
    return unless almostExpired()
    return if timeout?
    timeout = setTimeout tryManualRenewal, 10000
    FactlinkApp.facebookRenewalRegion.show new IframeView

  tryManualRenewal = ->
    return unless almostExpired()
    justRenewed = true
    FactlinkApp.NotificationCenter.error """
      Your Facebook connection could not be automatically verified.
      <a href="/auth/facebook" target="_blank" class="js-accounts-popup-link js-close">
        Verify manually.
      </a>
    """

  FacebookRenewal.success = ->
    clearTimeout timeout
    timeout      = null
    justRenewed  = true
    currentUser.fetch()
