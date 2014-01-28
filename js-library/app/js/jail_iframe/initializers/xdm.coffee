FactlinkJailRoot.createReceiverEnvoy FactlinkJailRoot.annotatedSiteReceiver

iframe = document.createElement('iframe')
iframe.id = "factlink-sidebar-frame"
iframe.src = "#{FactlinkConfig.api}/client/blank"
FactlinkJailRoot.$factlinkCoreContainer[0].appendChild(iframe)

FactlinkJailRoot.factlinkCoreEnvoy = FactlinkJailRoot.createSenderEnvoy iframe.contentWindow
FactlinkJailRoot.perf.add_timing_event('inserted core iframe')
FactlinkJailRoot.openFactlinkModal = (id) -> FactlinkJailRoot.factlinkCoreEnvoy 'showFactlink', id

FactlinkJailRoot.$sidebarFrame = $(iframe)
