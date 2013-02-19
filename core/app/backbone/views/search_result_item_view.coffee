window.getSearchResultItemView = (opts) ->
  switch opts.model.get("the_class")
    when "FactData"
      new FactView(model: new Fact(opts.model.get("the_object")))
    when "FactlinkUser"
      new UserSearchView(model: new User(opts.model.get("the_object")))
    when "Topic"
      new TopicSearchView(model: new Topic(opts.model.get("the_object")))
    else
      console.info "Unknown class of searchresult: ", opts.model.get("the_class")
      `undefined`
