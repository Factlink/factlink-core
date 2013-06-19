#= require_directory ./../regions

FactlinkApp.startSiteRegions = ->
  FactlinkApp.addRegions
    mainRegion:          '#main-wrapper'
    notificationsRegion: '#notifications'

    leftTopRegion:       '#left-column .js-left-top-region'
    leftBottomRegion:    '#left-column .js-left-bottom-region'
    leftMiddleRegion:    '#left-column .js-left-middle-region'

  FactlinkApp.closeAllContentRegions = ->
    for region in ['leftTopRegion', 'leftBottomRegion', 'leftMiddleRegion', 'mainRegion']
      FactlinkApp[region].close()

FactlinkApp.startClientRegions = ->
  FactlinkApp.addRegions
    mainRegion:          '.factlink-modal-content'
    topRegion:           '.js-region-factlink-modal-top'
    bottomRegion:        '.js-region-factlink-modal-bottom'
