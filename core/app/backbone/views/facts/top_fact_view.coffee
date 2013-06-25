class window.TopFactView extends Backbone.Marionette.Layout
  className: 'top-fact'

  template: 'facts/top_fact'

  regions:
    wheelRegion: '.js-fact-wheel-region'

  onRender: ->
    @wheelRegion.show @wheelView()

  wheelView: ->
    wheel = new Wheel @model.get('fact_wheel')

    wheel_view_options =
      fact: @model.attributes
      model: wheel
      radius: 45
      extraClassName: 'fact-wheel-large'

    if Factlink.Global.signed_in
      wheel_view = new InteractiveWheelView wheel_view_options
    else
      wheel_view = new BaseFactWheelView _.defaults(respondsToMouse: false, wheel_view_options)

    @bindTo @model, 'change', =>
      wheel.setRecursive @model.get("fact_wheel")
      wheel_view.render()

    wheel_view

