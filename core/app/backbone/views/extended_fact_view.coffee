class window.ExtendedFactView extends FactView
  tagName: "section"
  id: "main-wrapper"

  template: "facts/_extended_fact"

  initialize: (opts) ->
    super(opts)
    @factWheelView = new InteractiveWheelView({
      model: @wheel,
      fact: @model,
      el: @$('.wheel')
    })
    @initRenderActions()

  initRenderActions: () ->
    # the extended factpage is rendered in ruby, so the render of this view is never called,
    # therefore we have to force the rendering which we do need to do in the frontend in the initialize
    @renderAddToChannel()
    @factWheelView.render();
