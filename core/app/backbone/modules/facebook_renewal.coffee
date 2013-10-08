FactlinkApp.module "FacebookRenewal", (FacebookRenewal, FactlinkApp, Backbone, Marionette, $, _) ->

  FacebookRenewal.addInitializer ->
    if currentUser?.get('services')['facebook']
      days = 24*60*60*1000
      unix_timestamp = currentUser.get('services')['facebook_expires_at']
      expiry_date = new Date(unix_timestamp*1000)

      time_to_expiry = expiry_date - new Date

      #if time_to_expiry < 14*days
      tryRenewal()

  tryRenewal = ->
    FactlinkApp.NotificationCenter.error """
      Your Facebook connection could not be automatically verified. Please verify manually.
      <span class="social-services-buttons">
        <a href="/auth/facebook?return_to=/"
           target="_blank"
           class="button facebook popup js-close" data-disable-with="" data-width="640" data-height="400">
             <i></i>Verify
        </a>
      </span>
    """
