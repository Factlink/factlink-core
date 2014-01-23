FactlinkJailRoot.createButton = new FactlinkJailRoot.CreateButton

paragraphButtons = new FactlinkJailRoot.ParagraphButtons

FactlinkJailRoot.on 'factlink.factsLoaded coreLoad', ->
  paragraphButtons.addParagraphButtons()
