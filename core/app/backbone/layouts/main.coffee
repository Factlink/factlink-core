FactlinkApp.startSiteRegions = ->
  FactlinkApp.addRegions
    mainRegion:          '#main-wrapper'
    notificationsRegion: '#notifications'

    discussionModalRegion: '.js-discussion-modal-region'
    facebookRenewalRegion: '#js-facebook-renewal-region'

  FactlinkApp.closeAllContentRegions = ->
    for region in ['mainRegion']
      FactlinkApp[region].close()

FactlinkApp.startClientRegions = ->
  FactlinkApp.addRegions
    discussionModalRegion: '.js-discussion-modal-region'
    facebookRenewalRegion: '#js-facebook-renewal-region'
