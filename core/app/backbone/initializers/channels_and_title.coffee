FactlinkApp.addInitializer (options)->
  window.TitleManager = new WindowTitle()

  window.Global = {}

  window.Global.TitleView = new TitleView(model: window.TitleManager, el: 'title')
  window.Global.TitleView.render()
