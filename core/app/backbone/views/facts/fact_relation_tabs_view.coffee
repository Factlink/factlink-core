class window.FactRelationTabsView extends Backbone.Marionette.Layout
  template: "facts/fact_relations_tabs"

  className: "relation-tabs-view"

  events:
    "click .tab:not(.active)": "tabClick"

  regions:
    tabRegion: '.tab-content-container'

  onRender: -> @showTab("supporting")

  hideTabs: ->
    $tabButtons = @$(".tab-control li")
    $tabButtons.removeClass "active"

  showTab: (tab)->
    mp_track "Factlink: Open tab",
      factlink_id: @model.id
      type: tab

    @hideTabs()
    $tabHandle = @$(".tab-control>.#{tab}")
    $tabHandle.addClass "active"

    @showFactRelations tab

  onClose: -> delete @discussion

  cachedDiscussion: (type) ->
    @discussion ?= {}
    @discussion[type] ?= new Discussion
      fact: @model
      type: type

  showFactRelations: (type) ->

    if type == "doubting"
      relations_view = new DoubtingRelationsView model: @cachedDiscussion(type)
    else
      relations_view = new FactRelationsView model: @cachedDiscussion(type)

    @tabRegion.show relations_view

  tabClick: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $target = $(e.target).closest("li")
    tab = $target.attr("class").split(" ")[0]
    @showTab(tab)
