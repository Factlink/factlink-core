FactlinkApp.clientCloseModalWindowInitializer = (options) ->
  FactlinkApp.vent.on 'close_discussion_modal', ->
    parent.remote?.hide();
