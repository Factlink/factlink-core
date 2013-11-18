# Initiate the easyXDM object
Factlink.remote = new Factlink.easyXDM.Rpc {
  # The URL to load
  remote: "#{FactlinkConfig.api}/factlink/intermediate"
  # The iFrame where the intermediate should be loaded in
  container: 'factlink-modal-frame'
}, {
  # See modal.js #Factlink.modal
  local: Factlink.modal
  remote:
    showFactlink: {}
    prepareNewFactlink: {}
}
