FactlinkApp.clientCloseDiscussionModalInitializer = (options) ->
  FactlinkApp.vent.on 'close_discussion_modal', ->
    mp_track "Discussion Modal: Close (Button)"
    parent.remote?.closeModal_noAction();
