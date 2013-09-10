window.FactlinkConfig ?= {}
window.FactlinkConfig.api ?= 'https://factlink.com:443'
window.FactlinkConfig.lib ?= 'https://static.factlink.com:443/lib/dist'
window.FactlinkConfig.srcPath ?= '/factlink.core.min.js'

window.FACTLINK_START_LOADER()

window.FACTLINK.startHighlighting()
window.FACTLINK.startAnnotating()
window.FACTLINK.showLoadedNotification()
