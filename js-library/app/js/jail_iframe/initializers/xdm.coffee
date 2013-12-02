iframe = document.createElement('iframe')
frame_container = document.getElementById('factlink-modal-frame')
frame_container.appendChild(iframe)
Factlink.listenToWindowMessages Factlink.modal
iframe.src = "#{FactlinkConfig.api}/factlink/intermediate"

Factlink.remote = Factlink.createFrameProxyObject iframe.contentWindow, ['showFactlink', 'prepareNewFactlink' ]
