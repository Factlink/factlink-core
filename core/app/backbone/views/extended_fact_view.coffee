class window.ExtendedFactView extends FactView
  tagName: "section"
  id: "main-wrapper"

  template: "facts/_extended_fact"

  initialize: (opts) ->
    @model.bind('destroy', this.remove, this)
    @model.bind('change', this.render, this)

    @initAddToChannel()
    @renderAddToChannel() # sorry, dirty, but has to stay here, because we don't actually render this view
    @initFactRelationsViews()
    @initUserPassportViews()

    @wheel = new Wheel(@model.get('fact_wheel'))

    @factWheelView = new InteractiveWheelView({
      model: @wheel,
      fact: @model,
      el: @$('.wheel')
    }).render();
