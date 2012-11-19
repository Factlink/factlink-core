class window.FactRelationLayout extends Backbone.Marionette.Layout
  tagName: "li"
  className: "fact-relation"
  template: "fact_relations/fact_relations_layout"

  regions:
    factRelationRegion: ".fact_relation_region"
    voteRegion: '.vote_region'
    userRegion: 'henk'
    popoverRegion: '.popover_region'

  highlight: ->
    @$el.css background: '#ffffe1'

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
    @model.on "change", @render, @

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


class window.FactRelationView extends Backbone.Factlink.PlainView
  tagName: "div"
  className: "fact-relation-body"

  template: "fact_relations/fact_relation"

  partials:
    fact_base: "facts/_fact_base"
    fact_wheel: "facts/_fact_wheel"

  templateHelpers: =>
    user = new User( @model.get('created_by') )

    creator: user.toJSON()

  serializeData: -> _.extend super(), @templateHelpers()

  onRender: ->
    @wheelView = new InteractiveWheelView(
      el: @$(".fact-wheel")
      fact: @model.get("fact_base")
      model: new Wheel(@model.get("fact_base")["fact_wheel"])
    ).render()
    @

  onClose: -> @wheelView.close()

_.extend(FactRelationView.prototype, TemplateMixin)
