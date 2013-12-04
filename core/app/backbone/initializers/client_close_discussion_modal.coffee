FactlinkApp.clientCloseDiscussionModalInitializer = (annotatedSiteEnvoy) ->
  FactlinkApp.vent.on 'close_discussion_modal', ->
    mp_track "Discussion Modal: Close (Button)"
    annotatedSiteEnvoy 'closeModal_noAction'
