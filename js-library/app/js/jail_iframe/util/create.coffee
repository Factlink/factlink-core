FactlinkJailRoot.createFactFromSelection = (current_user_opinion) ->
  success = ->
    window.document.getSelection().removeAllRanges()
    FactlinkJailRoot.createButton.hide()
    FactlinkJailRoot.off 'modalOpened', success

  selInfo =
    text: window.document.getSelection().toString()
    title: window.document.title

  text = selInfo.text
  siteUrl = FactlinkJailRoot.siteUrl()
  siteTitle = selInfo.title

  FactlinkJailRoot.on 'modalOpened', success
  FactlinkJailRoot.factlinkCoreEnvoy 'prepareNewFactlink',
    text, siteUrl, siteTitle, current_user_opinion

FactlinkJailRoot.textSelected = ->
  # At least 4 words of at least 2 characters
  /(\w{2,}[\s-_&\/#%.,;:!()]+){4}/.test window.document.getSelection().toString()
