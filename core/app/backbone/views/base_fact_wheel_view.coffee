class window.BaseFactWheelView extends Backbone.Factlink.PlainView
  tagName: "div"
  className: "wheel"
  defaults:
    dimension: 16
    radius: 16
    minimalVisiblePercentage: 15
    defaultStroke:
      opacity: 0.2
      width: 9

    hoverStroke:
      opacity: 0.5
      width: 11

    userOpinionStroke:
      opacity: 1.0

    opinionStyles:      
      believe:
        groupname: Factlink.Global.t.fact_believe_opinion.titleize()
        color: "#98d100"
      doubt:
        groupname: Factlink.Global.t.fact_doubt_opinion.titleize()
        color: "#36a9e1"
      disbelieve:
        groupname: Factlink.Global.t.fact_disbelieve_opinion.titleize()
        color: "#e94e1b"


  template: "facts/_fact_wheel"
  initialize: (options) ->
    @options = $.extend({}, @defaults, options)
    @opinionTypeRaphaels = {}

  onRender: ->
    offset = 0
    @$el.html("<div class=\"html_container\"></div>").find(".html_container").html @templateRender(@model.toJSON())
    @canvas = Raphael(@el, @options.dimension * 2 + 12, @options.dimension * 2 + 12)
    @bindCustomRaphaelAttributes()
    @calculateDisplayablePercentages()
    for key, opinionType of @model.getOpinionTypes()
      @createOrAnimateArc opinionType, offset
      offset += opinionType.displayPercentage

    @bindTooltips()

  reRender: ->
    offset = 0
    @$el.find(".html_container").html @templateRender(@model.toJSON())
    @calculateDisplayablePercentages()
    for key, opinionType of @model.getOpinionTypes()
      @createOrAnimateArc opinionType, offset
      offset += opinionType.displayPercentage

    @bindTooltips()

  createOrAnimateArc: (opinionType, percentageOffset) ->
    opacity = (if opinionType.is_user_opinion then @options.userOpinionStroke.opacity else @options.defaultStroke.opacity)
    
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
      "stroke-width": @options.defaultStroke.width
      opacity: opacity
    
    # Bind Mouse Events on the path
    path.mouseover _.bind(@mouseoverOpinionType, this, path, opinionType)
    path.mouseout _.bind(@mouseoutOpinionType, this, path, opinionType)
    path.click _.bind(@clickOpinionType, this, opinionType)
    @opinionTypeRaphaels[opinionType.type] = path

  animateExistingArc: (opinionType, arc, opacity) ->
    # Retrieve the existing Raphael path belonging to this opinionType
    @opinionTypeRaphaels[opinionType.type].animate(
      # Our custom arc attribute
      arc: arc
      opacity: opacity
    , 200, "<>")
  
  # This method also commits the calculated percentages to the model, maybe return instead?
  calculateDisplayablePercentages: ->
    too_much = 0
    large_ones = 0

    for key, opinionType of @model.getOpinionTypes()
      percentage = opinionType.percentage
      if percentage < @options.minimalVisiblePercentage
        too_much += @options.minimalVisiblePercentage - percentage
      else large_ones += percentage  if percentage > 40

    for key, opinionType of @model.getOpinionTypes()
      percentage = opinionType.percentage
      if percentage < @options.minimalVisiblePercentage
        percentage = @options.minimalVisiblePercentage
      else percentage = percentage - ((percentage / large_ones) * too_much)  if percentage > 40
      opinionType.displayPercentage = percentage

  bindCustomRaphaelAttributes: ->
    @canvas.customAttributes.arc = (percentage, percentageOffset, radius) =>
      percentage = percentage - 2 # add padding after arc
      largeAngle = percentage > 50
      boxDimension = @options.dimension + 6
      startAngle = percentageOffset * 2 * Math.PI / 100
      endAngle = (percentageOffset + percentage) * 2 * Math.PI / 100
      startX = boxDimension + radius * Math.cos(startAngle)
      startY = boxDimension - radius * Math.sin(startAngle)
      endX = boxDimension + radius * Math.cos(endAngle)
      endY = boxDimension - radius * Math.sin(endAngle)
      path: [["M", startX, startY], ["A", radius, radius, 0, ((if largeAngle then 1 else 0)), 0, endX, endY]]

  mouseoverOpinionType: (path, opinionType) ->
    destinationOpacity = @options.hoverStroke.opacity
    destinationOpacity = @options.userOpinionStroke.opacity  if opinionType.is_user_opinion
    path.animate(
      "stroke-width": @options.hoverStroke.width
      opacity: destinationOpacity
    , 200, "<>")

  mouseoutOpinionType: (path, opinionType) ->
    destinationOpacity = @options.defaultStroke.opacity
    destinationOpacity = @options.userOpinionStroke.opacity  if opinionType.is_user_opinion
    path.animate(
      "stroke-width": @options.defaultStroke.width
      opacity: destinationOpacity
    , 200, "<>")

  clickOpinionType: ->

  bindTooltips: ->
    $("div.tooltip", @$el).remove()
    @$el.find(".authority").tooltip title: "This number represents the amount of thinking " + "spent by people on this Factlink"
    
    # Create tooltips for each opinionType (believe, disbelieve etc)
    for key, opinionType of @model.getOpinionTypes()
      raphaelObject = @opinionTypeRaphaels[opinionType.type]
      $(raphaelObject.node).tooltip
        title: @options.opinionStyles[opinionType.type].groupname + ": " + opinionType.percentage + "%"
        placement: "left"

  updateTo: (authority, opinionTypes) ->
    @model.set "authority", authority
    if _.isArray(opinionTypes)
      tempObject = {}
      _.each opinionTypes, (opinionType) ->
        tempObject[opinionType.type] = opinionType

      opinionTypes = tempObject
    for key, opinionType of @model.getOpinionTypes()
      newOpinionType = opinionTypes[opinionType.type]
      opinionType.percentage = newOpinionType.percentage
      opinionType.is_user_opinion = newOpinionType.is_user_opinion

    @reRender()

  toggleActiveOpinionType: (opinionType) ->
    oldAuthority = @model.get("authority")
    updateObj = {}
    _.each @model.getOpinionTypes(), (oldOpinionType) ->
      updateObj[oldOpinionType.type] = _.clone(oldOpinionType)
      unless opinionType.is_user_opinion
        updateObj[oldOpinionType.type].is_user_opinion = false
      if oldOpinionType == opinionType
        updateObj[oldOpinionType.type].is_user_opinion = !opinionType.is_user_opinion

    @updateTo oldAuthority, updateObj
