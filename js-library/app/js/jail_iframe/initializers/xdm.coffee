iframe = document.createElement('iframe')
frame_container = document.getElementById('factlink-modal-frame')
frame_container.appendChild(iframe)
FactlinkJailRoot.listenToWindowMessages FactlinkJailRoot.messageReceiver
iframe.src = "#{FactlinkConfig.api}/factlink/intermediate"

FactlinkJailRoot.remote = FactlinkJailRoot.createFrameProxyObject iframe.contentWindow, ['showFactlink', 'prepareNewFactlink' ]
