describe "FactView", ->
  it "should call render", ->
    model = new Fact(displaystring: "test")
    spyOn model, "getFactWheel"
    spyOn(window, "Wheel").andReturn set: ->

    spyOn(window, "InteractiveWheelView").andReturn render: ->

    spyOn(window, "FactTabsView").andReturn render: ->

    render = spyOn(Backbone.Marionette.Renderer, "render")
    view = new FactView(model: model)
    view.render()
    expect(Backbone.Marionette.Renderer.render).toHaveBeenCalledWith "facts/_fact",
      displaystring: "test"
    ,
      fact_base: `undefined`
      fact_wheel: `undefined`
      interacting_users: `undefined`
