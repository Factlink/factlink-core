FactlinkJailRoot.createButton = new FactlinkJailRoot.CreateButton

paragraphButtons = new FactlinkJailRoot.ParagraphButtons

FactlinkJailRoot.on 'coreLoad', ->
  paragraphButtons.addParagraphButtons()
