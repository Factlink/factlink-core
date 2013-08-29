FactlinkApp.clientCloseDiscussionModalInitializer = (options) ->
  FactlinkApp.vent.on 'close_discussion_modal', ->
    mp_track "Client Discussion Modal: Close"
    parent.remote?.hide();
