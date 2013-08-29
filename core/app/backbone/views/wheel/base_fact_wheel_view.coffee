arc_animation_speed = ->
  if $.fx.off
    0
  else
    200

class window.BaseFactWheelView extends Backbone.Marionette.ItemView
  className: "wheel"
  defaults:
    respondsToMouse: true
    showsTooltips: true
    radius: 16

    minimalVisiblePercentage: 15

    defaultStrokeOpacity: 0.2
    hoverStrokeOpacity: 0.5
    userOpinionStrokeOpacity: 1.0

    opinionStyles:
      believe:
        groupname: Factlink.Global.t.fact_believe_opinion?.titleize()
        color: "#98d100"
      doubt:
        groupname: Factlink.Global.t.fact_doubt_opinion?.titleize()
        color: "#36a9e1"
      disbelieve:
        groupname: Factlink.Global.t.fact_disbelieve_opinion?.titleize()
        color: "#e94e1b"

  template: "facts/fact_wheel"

  initialize: (options) ->
    @options = $.extend(true, {}, BaseFactWheelView.prototype.defaults, @defaults, options)
    @opinionTypeRaphaels = {}
    @listenTo @model, 'change', @reRender, @

  defaultStrokeWidth: -> 3/5 * @options.radius
  hoverStrokeWidth: -> @defaultStrokeWidth() + 2
  maxStrokeWidth: -> Math.max(@defaultStrokeWidth(), @hoverStrokeWidth())

  onRender: ->
    @renderRaphael()
    @postRenderActions()

  render: ->
    if @already_rendered
      @reRender()
    else
      super()
      @already_rendered = true
    @

  renderRaphael: ->
    @$canvasEl = $('<div></div>')
    @$canvasEl.addClass 'fact-wheel-responding-to-mouse' if @options.respondsToMouse

    @$('.raphael_container').html(@$canvasEl)
    @canvas = Raphael @$canvasEl[0], @boxSize(), @boxSize()
    @bindCustomRaphaelAttributes()

  boxSize: -> @options.radius * 2 + @maxStrokeWidth()

  reRender: ->
    @$('.authority').text(@model.get('authority'))
    @postRenderActions()

  postRenderActions: ->
    offset = 0
    @calculateDisplayablePercentages()
    for key, opinionType of @model.get('opinion_types')
      @createOrAnimateArc opinionType, offset
      offset += opinionType.displayPercentage
    @bindTooltips()

  createOrAnimateArc: (opinionType, percentageOffset) ->
    opacity = (if opinionType.is_user_opinion then @options.userOpinionStrokeOpacity else @options.defaultStrokeOpacity)

    # Our custom Raphael arc attribute
    arc = [opinionType.displayPercentage, percentageOffset, @options.radius]
    if @opinionTypeRaphaels[opinionType.type]
      @animateExistingArc opinionType, arc, opacity
    else
      @createArc opinionType, arc, opacity

  createArc: (opinionType, arc, opacity) ->
    # Create a path in the global Raphael canvas and store it in opinionTypeRaphaels
    path = @canvas.path().attr
      # Our custom arc attribute
      arc: arc
      stroke: @options.opinionStyles[opinionType.type].color
      "stroke-width": @defaultStrokeWidth()
      opacity: opacity

    # Bind Mouse Events on the path
    if @options.respondsToMouse || @options.showsTooltips
      path.mouseover _.bind(@mouseoverOpinionType, this, path, opinionType.type)
      path.mouseout _.bind(@mouseoutOpinionType, this, path, opinionType.type)
      path.click _.bind(@clickOpinionType, this, opinionType.type)

    @opinionTypeRaphaels[opinionType.type] = path

  animateExistingArc: (opinionType, arc, opacity) ->
    # Retrieve the existing Raphael path belonging to this opinionType
    @opinionTypeRaphaels[opinionType.type].animate(
      # Our custom arc attribute
      arc: arc
      opacity: opacity
    , arc_animation_speed(), "<>")

  # This method also commits the calculated percentages to the model, maybe return instead?
  calculateDisplayablePercentages: ->
    too_much = 0
    large_ones = 0

    for key, opinionType of @model.get('opinion_types')
      percentage = opinionType.percentage
      if percentage < @options.minimalVisiblePercentage
        too_much += @options.minimalVisiblePercentage - percentage
      else large_ones += percentage  if percentage > 40

    for key, opinionType of @model.get('opinion_types')
      percentage = opinionType.percentage
      if percentage < @options.minimalVisiblePercentage
        percentage = @options.minimalVisiblePercentage
      else percentage = percentage - ((percentage / large_ones) * too_much)  if percentage > 40
      opinionType.displayPercentage = percentage

  bindCustomRaphaelAttributes: ->
    polarToRegular = (origin, radius, angle)->
      x: origin[0] + radius * Math.cos(angle),
      y: origin[1] - radius * Math.sin(angle)

    @canvas.customAttributes.arc = (percentage, percentageOffset, radius) =>
      paddingPixels = 2
      paddingRadians = paddingPixels / @options.radius

      startAngle = percentageOffset / 100 * 2 * Math.PI
      endAngle = startAngle + percentage / 100 * 2 * Math.PI - paddingRadians

      origin = [@boxSize() / 2, @boxSize() / 2]

      start = polarToRegular(origin, radius, startAngle)
      end = polarToRegular(origin, radius, endAngle)

      direction = if percentage > 50 then 1 else 0
      path: [["M", start.x, start.y], ["A", radius, radius, 0, direction, 0, end.x, end.y]]

  mouseoverOpinionType: (path, opinion_type) ->
    destinationOpacity = if @model.isUserOpinion(opinion_type)
                           @options.userOpinionStrokeOpacity
                         else
                           @options.hoverStrokeOpacity

    path.animate(
      "stroke-width": @hoverStrokeWidth()
      opacity: destinationOpacity
    , arc_animation_speed(), "<>")

  mouseoutOpinionType: (path, opinion_type) ->
    destinationOpacity = if @model.isUserOpinion(opinion_type)
                           @options.userOpinionStrokeOpacity
                         else
                           @options.defaultStrokeOpacity
    path.animate(
      "stroke-width": @defaultStrokeWidth()
      opacity: destinationOpacity
    , arc_animation_speed(), "<>")

  clickOpinionType: ->

  bindTooltips: ->
    if @options.showsTooltips
      @$("div.tooltip").remove()
      @$(".authority").tooltip title: "This number represents the amount of thinking " + "spent by people on this Factlink"

      # Create tooltips for each opinionType (believe, disbelieve etc)
      for key, opinionType of @model.get('opinion_types')
        raphaelObject = @opinionTypeRaphaels[opinionType.type]
        $(raphaelObject.node).tooltip
          title: @options.opinionStyles[opinionType.type].groupname + ": " + opinionType.percentage + "%"
          placement: "left"
