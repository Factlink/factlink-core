FactlinkJailRoot.core_loaded_promise.then ->
  open_id =
    /#factlink-open-(\d+)/i.exec(window.location.hash)?[1] ||
    /(^\?|\&)(factlink_)?open_id=(\d+)($|&)/.exec(window.location.search)?[3]
    # ?open_id= is a legacy syntax which this version no longer uses.
    # If it is removed, previously shared URI's (before 2014-feb) may break
    # and only link to the host page, without opening the intended factlink.
  if open_id
    FactlinkJailRoot.scrollTo parseInt(open_id)
    FactlinkJailRoot.openFactlinkModal parseInt(open_id)
