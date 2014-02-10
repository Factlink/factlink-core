FactlinkJailRoot.core_loaded_promise.then ->
  open_id =
    /#factlink-open-(\d+)/i.exec(window.location.hash)?[1] ||
    /(^\?|\&)(factlink_)?open_id=(\d+)($|&)/.exec(window.location.search)?[3]
  if open_id
    FactlinkJailRoot.scrollTo parseInt(open_id)
    FactlinkJailRoot.openFactlinkModal parseInt(open_id)
