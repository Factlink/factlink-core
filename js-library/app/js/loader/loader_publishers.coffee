window.FactlinkConfig ?= {}
window.FactlinkConfig.api ?= 'https://factlink.com:443'
window.FactlinkConfig.lib ?= 'https://static.factlink.com:443/lib/dist'
window.FactlinkConfig.srcPath ?= '/factlink.core.min.js'

window.FACTLINK_START_LOADER()

window.FACTLINK.startHighlighting()
window.FACTLINK.startAnnotating()

openId = /#factlink-open-(\d+)/i.exec(window.location.hash)?[1]
scrollToId = openId ? /#factlink-(\d+)/i.exec(window.location.hash)?[1]

window.FACTLINK.scrollTo parseInt(scrollToId) if scrollToId?
window.FACTLINK.openFactlinkModal parseInt(openId) if openId?
