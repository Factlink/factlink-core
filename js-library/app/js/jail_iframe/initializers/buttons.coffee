FactlinkJailRoot.createButton = new FactlinkJailRoot.CreateButton

paragraphButtons = new FactlinkJailRoot.ParagraphButtons

FactlinkJailRoot.loaded_promise.then ->
  paragraphButtons.addParagraphButtons()
