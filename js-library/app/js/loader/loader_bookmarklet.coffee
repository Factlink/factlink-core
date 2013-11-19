window.FactlinkConfig ?= {}
window.FactlinkConfig.api ?= 'https://factlink.com:443'

window.FACTLINK_START_LOADER()

window.FACTLINK.startHighlighting()
window.FACTLINK.startAnnotating()
window.FACTLINK.showLoadedNotification()
