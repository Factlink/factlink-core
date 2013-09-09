# Initiate the easyXDM object
FACTLINK.remote = new FACTLINK.easyXDM.Rpc {
  # The URL to load
  remote: "#{FactlinkConfig.api}/factlink/intermediate"
  # The iFrame where the intermediate should be loaded in
  container: 'factlink-modal-frame'
}, {
  # See modal.js #FACTLINK.modal
  local: FACTLINK.modal
  remote:
    showFactlink: {}
    prepareNewFactlink: {}
    position: {}
}
