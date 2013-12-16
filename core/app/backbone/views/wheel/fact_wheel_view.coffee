arc_animation_speed = ->
  if $.fx.off
    0
  else
    200

class window.FactWheelView extends Backbone.Marionette.ItemView
  className: "wheel"
  defaults:
    respondsToMouse: true
    showsTooltips: true
    showsTotalVotesTooltip: true
    radius: 16

    minimalVisibleFraction: 0.15

    defaultStrokeOpacity: 0.2
    hoverStrokeOpacity: 0.5
    userOpinionStrokeOpacity: 1.0

    opinionStyles:
      believes:
        attributeName: 'believes_count'
        groupname: Factlink.Global.t.fact_believe_opinion?.titleize()
        color: "#98d100"
      doubts:
        attributeName: 'doubts_count'
        groupname: Factlink.Global.t.fact_doubt_opinion?.titleize()
        color: "#36a9e1"
      disbelieves:
        attributeName: 'disbelieves_count'
        groupname: Factlink.Global.t.fact_disbelieve_opinion?.titleize()
        color: "#e94e1b"

  template: "facts/fact_wheel"

  templateHelpers: ->
    formatted_total_votes: format_as_short_number(@model.totalCount())

  initialize: (options) ->
    @options = $.extend(true, {}, FactWheelView.prototype.defaults, @defaults, options)
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
    @$('.js-total-votes').text format_as_short_number(@model.totalCount())
    @postRenderActions()

  postRenderActions: ->
    fractionOffset = 0
    for type, fraction of @displayableFractions()
      @createOrAnimateArc type, fraction, fractionOffset
      fractionOffset += fraction

    @bindTooltips()

  createOrAnimateArc: (type, fraction, fractionOffset) ->
    opacity = (if @model.get('current_user_opinion') == type then @options.userOpinionStrokeOpacity else @options.defaultStrokeOpacity)

    # Our custom Raphael arc attribute
    arc = [fraction, fractionOffset, @options.radius]
    if @opinionTypeRaphaels[type]
      @animateExistingArc type, arc, opacity
    else
      @createArc type, arc, opacity

  createArc: (type, arc, opacity) ->
    # Create a path in the global Raphael canvas and store it in opinionTypeRaphaels
    path = @canvas.path().attr
      # Our custom arc attribute
      arc: arc
      stroke: @options.opinionStyles[type].color
      "stroke-width": @defaultStrokeWidth()
      opacity: opacity

    # Bind Mouse Events on the path
    if @options.respondsToMouse || @options.showsTooltips
      path.mouseover _.bind(@mouseoverOpinionType, this, path, type)
      path.mouseout _.bind(@mouseoutOpinionType, this, path, type)
      path.click _.bind(@clickOpinionType, this, type)

    @opinionTypeRaphaels[type] = path

  animateExistingArc: (type, arc, opacity) ->
    # Retrieve the existing Raphael path belonging to this type
    @opinionTypeRaphaels[type].animate(
      # Our custom arc attribute
      arc: arc
      opacity: opacity
    , arc_animation_speed(), "<>")

  wheelCounts: ->
    if @model.totalCount() > 0
      _.extend {total: @model.totalCount()}, @model.attributes
    else
      return {believes: 0, disbelieves: 0, doubts: 1, total: 1}

  displayableFractions: ->
    counts = @wheelCounts()
    fractions = {}
    too_much = 0
    large_ones = 0

    for key, opinionStyle of @options.opinionStyles
      fractions[key] = counts[key] / counts.total

      if fractions[key] < @options.minimalVisibleFraction
        too_much += @options.minimalVisibleFraction - fractions[key]
        fractions[key] = @options.minimalVisibleFraction
      else if fractions[key] > 0.4
        large_ones += fractions[key]

    for key, fraction of fractions
      if fractions[key] > 0.4
        fractions[key] -= ((fractions[key] / large_ones) * too_much)

    fractions

  bindCustomRaphaelAttributes: ->
    polarToRegular = (origin, radius, angle)->
      x: origin[0] + radius * Math.cos(angle),
      y: origin[1] - radius * Math.sin(angle)

    @canvas.customAttributes.arc = (fraction, fractionOffset, radius) =>
      paddingPixels = 2
      paddingRadians = paddingPixels / @options.radius

      startAngle = fractionOffset * 2 * Math.PI
      endAngle = startAngle + fraction * 2 * Math.PI - paddingRadians

      origin = [@boxSize() / 2, @boxSize() / 2]

      start = polarToRegular(origin, radius, startAngle)
      end = polarToRegular(origin, radius, endAngle)

      direction = if fraction > 0.5 then 1 else 0
      path: [["M", start.x, start.y], ["A", radius, radius, 0, direction, 0, end.x, end.y]]

  mouseoverOpinionType: (path, opinion_type) ->
    destinationOpacity = if @model.get('current_user_opinion') == opinion_type
                           @options.userOpinionStrokeOpacity
                         else
                           @options.hoverStrokeOpacity

    path.animate(
      "stroke-width": @hoverStrokeWidth()
      opacity: destinationOpacity
    , arc_animation_speed(), "<>")

  mouseoutOpinionType: (path, opinion_type) ->
    destinationOpacity = if @model.get('current_user_opinion') == opinion_type
                           @options.userOpinionStrokeOpacity
                         else
                           @options.defaultStrokeOpacity
    path.animate(
      "stroke-width": @defaultStrokeWidth()
      opacity: destinationOpacity
    , arc_animation_speed(), "<>")

  clickOpinionType: (opinion_type) ->
    if @model.get('current_user_opinion') == opinion_type
      @model.saveCurrentUserOpinion 'no_vote'
    else
      @model.saveCurrentUserOpinion opinion_type

  bindTooltips: (fractions) ->
    if @options.showsTooltips
      @trigger 'removeTooltips'

      @_makeTotalVotesTooltip()
      @_makeTooltipForPath 'believes', 'path:nth-of-type(1)'
      @_makeTooltipForPath 'doubts', 'path:nth-of-type(2)'
      @_makeTooltipForPath 'disbelieves', 'path:nth-of-type(3)'

  _makeTotalVotesTooltip: ->
    return unless @options.showsTotalVotesTooltip

    Backbone.Factlink.makeTooltipForView @,
      positioning:
        side: 'top'
        popover_className: 'translucent-popover'
        margin: @maxStrokeWidth()/2 - 7
      selector: '.js-total-votes'
      tooltipViewFactory: => new TextView text: 'Total votes'

  _makeTooltipForPath: (type, selector) ->
    Backbone.Factlink.makeTooltipForView @,
      positioning:
        side: @_tooltipSideForPath(@opinionTypeRaphaels[type])
        popover_className: 'translucent-popover'
        margin: @maxStrokeWidth()/2 - 3
      selector: selector
      tooltipViewFactory: =>
        name = @options.opinionStyles[type].groupname
        count = @model.get(type)
        new TextView text: "#{name}: #{count}"

  _tooltipSideForPath: (path) ->
    bbox = path.getBBox()
    if bbox.x + bbox.width/2 > @boxSize()/2 then 'right' else 'left'
