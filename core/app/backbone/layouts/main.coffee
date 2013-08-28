FactlinkApp.startSiteRegions = ->
  FactlinkApp.addRegions
    mainRegion:          '#main-wrapper'
    notificationsRegion: '#notifications'

    leftTopRegion:       '#left-column .js-left-top-region'
    leftBottomRegion:    '#left-column .js-left-bottom-region'
    leftMiddleRegion:    '#left-column .js-left-middle-region'

    clientModalRegion: '.js-client-modal-region-in-frontend'

  FactlinkApp.closeAllContentRegions = ->
    for region in ['leftTopRegion', 'leftBottomRegion', 'leftMiddleRegion', 'mainRegion']
      FactlinkApp[region].close()

FactlinkApp.startClientRegions = ->
  FactlinkApp.addRegions
    clientModalRegion: '.js-client-modal-region'
