FactlinkApp.startSiteRegions = ->
  FactlinkApp.addRegions
    mainRegion:          '#main-wrapper'
    notificationsRegion: '#notifications'

    leftTopRegion:       '#left-column .js-left-top-region'
    leftBottomRegion:    '#left-column .js-left-bottom-region'
    leftMiddleRegion:    '#left-column .js-left-middle-region'

    discussionModalRegion: '.js-discussion-modal-region'
    facebookRenewalRegion: '#js-facebook-renewal-region'

  FactlinkApp.closeAllContentRegions = ->
    for region in ['leftTopRegion', 'leftBottomRegion', 'leftMiddleRegion', 'mainRegion']
      FactlinkApp[region].close()

FactlinkApp.startClientRegions = ->
  FactlinkApp.addRegions
    discussionModalRegion: '.js-discussion-modal-region'
    facebookRenewalRegion: '#js-facebook-renewal-region'
