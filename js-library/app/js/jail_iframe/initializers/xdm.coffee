frame_container = FactlinkJailRoot.$factlinkCoreContainer[0]
iframe = document.createElement('iframe')
frame_container.appendChild(iframe)
FactlinkJailRoot.createReceiverEnvoy FactlinkJailRoot.annotatedSiteReceiver
iframe.id = "factlink-sidebar-frame"
iframe.src = "#{FactlinkConfig.api}/client/blank"
FactlinkJailRoot.factlinkCoreEnvoy = FactlinkJailRoot.createSenderEnvoy iframe.contentWindow

FactlinkJailRoot.openFactlinkModal = (id) -> FactlinkJailRoot.factlinkCoreEnvoy 'showFactlink', id

FactlinkJailRoot.$sidebarFrame = $(iframe)
