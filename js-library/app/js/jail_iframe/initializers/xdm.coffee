iframe = document.createElement('iframe')
frame_container = document.getElementById('factlink-modal-frame')
frame_container.appendChild(iframe)
FactlinkJailRoot.createReceiverEnvoy FactlinkJailRoot.annotatedSiteReceiver
iframe.src = "#{FactlinkConfig.api}/factlink/intermediate"

FactlinkJailRoot.factlinkCoreEnvoy = FactlinkJailRoot.createSenderEnvoy iframe.contentWindow, ['showFactlink', 'prepareNewFactlink' ]
