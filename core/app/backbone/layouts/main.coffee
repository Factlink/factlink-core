#= require_directory ./../regions

FactlinkApp.startSiteRegions = ->
  FactlinkApp.addRegions
    mainRegion:          '#main-wrapper'
    notificationsRegion: '#notifications'

    leftTopCrossFadeRegion:  CrossFadeRegion.extend( el: '#left-column .left-top-x-fade' )
    leftTopRegion:       '#left-column .user-block-container'
    leftBottomRegion:    '#left-column .js-related-channels'
    leftMiddleRegion:    '#left-column .channel-listing-container'

  FactlinkApp.closeAllContentRegions = ->
    for region in ['leftTopCrossFadeRegion', 'leftTopRegion', 'leftBottomRegion', 'leftMiddleRegion', 'mainRegion']
      FactlinkApp[region].close()

FactlinkApp.startClientRegions = ->
  FactlinkApp.addRegions
    mainRegion:          '.factlink-modal-content'
    topRegion:           '.js-region-factlink-modal-top'
    bottomRegion:        '.js-region-factlink-modal-bottom'
