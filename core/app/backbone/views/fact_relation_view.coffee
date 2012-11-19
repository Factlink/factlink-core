class window.FactRelationLayout extends Backbone.Marionette.Layout
  tagName: "li"
  className: "fact-relation"
  template: "fact_relations/fact_relations_layout"

  regions:
    factRelationRegion: ".factRelationRegion"

  onRender: ->
    fact_relation_view = new FactRelationView(model: @model)
    @factRelationRegion.show fact_relation_view


ViewWithPopover = extendWithPopover(Backbone.Factlink.PlainView)

class window.FactRelationView extends ViewWithPopover
  tagName: "div"
  className: "aaaaap-fact-relation"

  events:
    "click .fact-relation-actions>.weakening": "disbelieveFactRelation"
    "click .fact-relation-actions>.supporting": "believeFactRelation"
    "click li.delete": "destroyFactRelation"

  template: "fact_relations/fact_relation"

  partials:
    fact_base: "facts/_fact_base"
    fact_wheel: "facts/_fact_wheel"

  popover: [
    selector: ".relation-top-right-arrow"
    popoverSelector: "ul.relation-top-right"
  ]

  initialize: ->
    @model.on "destroy", @remove, @
    @model.on "change",  @render, @

  remove: ->
    $el = @$el
    $el.fadeOut "fast", ->
      $el.remove()

  destroyFactRelation: ->
    @model.destroy()

  render: ->
    $("a.weakening", @$el).tooltip "hide"
    $("a.supporting", @$el).tooltip "hide"
    @$el.html @templateRender(@model.toJSON())
    @wheelView = new InteractiveWheelView(
      el: @$el.find(".fact-wheel")
      fact: @model.get("fact_base")
      model: new Wheel(@model.get("fact_base")["fact_wheel"])
    ).render()
    $("a.supporting", @$el).tooltip title: "This is relevant"
    $("a.weakening", @$el).tooltip
      title: "This is not relevant"
      placement: "bottom"

    weight = @model.get("weight")
    weightTooltipText = "This fact influences the top fact a lot"
    if weight < 33
      weightTooltipText = "This fact doesn't influence the top fact that much"
    else weightTooltipText = "This fact influences the top fact a little bit"  if weight < 66
    @$el.find(".weight-container").tooltip title: weightTooltipText
    @

  disbelieveFactRelation: -> @model.disbelieve()
  believeFactRelation:    -> @model.believe()

  highlight: ->
    @$el.animate
      "background-color": "#ffffe1"
    ,
      duration: 2000
      complete: ->
        $(this).animate
          "background-color": "#ffffff"
        , 2000

