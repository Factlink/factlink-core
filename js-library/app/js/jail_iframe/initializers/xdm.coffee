FactlinkJailRoot.createReceiverEnvoy FactlinkJailRoot.annotatedSiteReceiver

iframe = document.createElement('iframe')
iframe.id = "factlink-sidebar-frame"
iframe.src = "#{FactlinkConfig.base_uri}/client/blank"
FactlinkJailRoot.$factlinkCoreContainer[0].appendChild(iframe)

real_envoy =  FactlinkJailRoot.createSenderEnvoy iframe.contentWindow
FactlinkJailRoot.factlinkCoreEnvoy = (args...) -> FactlinkJailRoot.core_loaded_promise.done -> real_envoy(args...)
FactlinkJailRoot.perf.add_timing_event('inserted core iframe')

FactlinkJailRoot.openFactlinkModal = (id) ->
  FactlinkJailRoot.openModalOverlay()
  FactlinkJailRoot.factlinkCoreEnvoy 'showFactlink', id, FactlinkJailRoot.siteUrl()

FactlinkJailRoot.$sidebarFrame = $(iframe)
