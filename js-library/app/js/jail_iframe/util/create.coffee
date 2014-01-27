FactlinkJailRoot.createFactFromSelection = (current_user_opinion) ->
  success = ->
    window.document.getSelection().removeAllRanges()
    FactlinkJailRoot.createButton.stopLoading()
    FactlinkJailRoot.createButton.hide()
    FactlinkJailRoot.off 'modalOpened', success

  text = window.document.getSelection().toString()
  siteTitle = window.document.title
  siteUrl = FactlinkJailRoot.siteUrl()

  FactlinkJailRoot.on 'modalOpened', success
  FactlinkJailRoot.factlinkCoreEnvoy 'prepareNewFactlink',
    text, siteUrl, siteTitle, current_user_opinion

FactlinkJailRoot.textSelected = ->
  # At least 4 words of at least 2 characters
  /(\w{2,}[\s-_&\/#%.,;:!()]+){4}/.test window.document.getSelection().toString()
