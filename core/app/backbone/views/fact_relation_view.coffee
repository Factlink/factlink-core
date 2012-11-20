class window.FactRelationLayout extends Backbone.Marionette.Layout
  tagName: "li"
  className: "fact-relation"
  template: "fact_relations/fact_relations_layout"

  regions:
    factRelationRegion: ".fact_relation_region"
    voteRegion: '.vote_region'
    popoverRegion: '.popover_region'

  highlight: ->
    @$el.animate
      "background-color": "#ffffe1"
    ,
      duration: 500
      complete: ->
        $(this).animate
          "background-color": "#ffffff"
        , 2500

  onRender: ->
    @factRelationRegion.show new FactRelationView model: @model
    @voteRegion.show new VoteUpDownView model: @model

    if @model.get('can_destroy?')
      @popoverRegion.show new FactRelationPopoverView model: @model


class VoteUpDownView extends Backbone.Marionette.ItemView
  className: 'fact-relation-actions'
  template: 'fact_relations/vote_up_down'

  events:
    "click .weakening": "disbelieve"
    "click .supporting": "believe"

  initialize: ->
    @bindTo @model, "change", @render, @

  hideTooltips: ->
    @$(".weakening").tooltip "hide"
    @$(".supporting").tooltip "hide"

  onRender: ->
    @$(".supporting").tooltip title: "This is relevant"
    @$(".weakening").tooltip
      title: "This is not relevant"
      placement: "bottom"

  disbelieve: ->
    @hideTooltips()
    @model.disbelieve()

  believe: ->
    @hideTooltips()
    @model.believe()


ViewWithPopover = extendWithPopover(Backbone.Marionette.ItemView)

class FactRelationPopoverView extends ViewWithPopover
  template: "fact_relations/fact_relation_popover"

  events:
    "click li.delete": "destroy"

  popover: [
    selector: ".relation-top-right-arrow"
    popoverSelector: "ul.relation-top-right"
  ]

  destroy: -> @model.destroy()

class FactRelationActivityView extends Backbone.Marionette.ItemView
  template:
    text: """
    <strong>
    <a href="/{{ creator.username }}" rel="backbone">{{ creator.username }}</a>
  </strong>
  ( <img src="{{global.brain_image}}"> {{ creator.authority }} ) added:
    """

  className: "fact-relation-added-by"

  initialize: ->
    @bindTo @model, 'change', @render, @

  templateHelpers: =>
    creator: @model.creator().toJSON()

class FactBaseView extends Backbone.Marionette.ItemView
  template:
    text: """
      {{fact_base.displaystring}}
      <a class="less" style="display:none">(less)</a>
    """

  className: "fact-body"

  initialize: ->
    @bindTo @model, 'change', @render, @

class window.FactRelationView extends Backbone.Marionette.Layout
  className: "fact-relation-body"

  template: "fact_relations/fact_relation"

  regions:
    factRelationActivityView: '.fact-relation-added-by-region'
    factBaseView:             '.fact-base-region'
    factWheelRegion:          '.fact-wheel'

  templateHelpers: =>
    creator: @model.creator().toJSON()

  onRender: ->
    @factWheelRegion.show @wheelView()
    @factBaseView.show new FactBaseView(model: @model)
    @factRelationActivityView.show new FactRelationActivityView(model: @model)

  wheelView: ->
    wheel = new Wheel(@model.get("fact_base")["fact_wheel"])
    @_wheelView = new InteractiveWheelView
      fact: @model.get("fact_base")
      model: wheel

    @bindTo @model, 'change', =>
      wheel.set @model.get("fact_base")["fact_wheel"]
      @_wheelView.render()

    @_wheelView
