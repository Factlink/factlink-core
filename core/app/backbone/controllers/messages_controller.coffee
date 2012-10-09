app = FactlinkApp

class window.MessagesController
  showMessage: (message_id)->
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    @main.showTitle "Message #{message_id}"
    @main.contentRegion.show(new MessageView())
