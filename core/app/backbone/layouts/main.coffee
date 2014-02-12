FactlinkApp.startSiteRegions = ->
  FactlinkApp.addRegions
    mainRegion:              '#main-wrapper'
    discussionSidebarRegion: '.js-discussion-sidebar-region'
    facebookRenewalRegion:   '#js-facebook-renewal-region'

FactlinkApp.startClientRegions = ->
  FactlinkApp.addRegions
    discussionSidebarRegion: '.js-discussion-sidebar-region'
    facebookRenewalRegion:   '#js-facebook-renewal-region'
