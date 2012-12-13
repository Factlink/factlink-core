#= require_directory ./../regions

FactlinkApp.addRegions
  mainRegion:          '#main-wrapper'
  notificationsRegion: '#notifications'

  leftTopCrossFadeRegion:  crossFadeRegion.extend( el: '#left-column .left-top-x-fade' )
  leftTopRegion:       '#left-column .user-block-container'
  leftBottomRegion:    '#left-column .js-related-channels'
  leftMiddleRegion:    '#left-column .channel-listing-container'

FactlinkApp.closeAllContentRegions = ->
  for region in ['leftTopCrossFadeRegion', 'leftTopRegion', 'leftBottomRegion', 'leftMiddleRegion', 'mainRegion']
    FactlinkApp[region].close()
