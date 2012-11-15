class window.FactRelationTabsView extends Backbone.Marionette.Layout
  template: "facts/fact_relations_tabs"

  className: "relation-tabs-view"

  events:
    "click .tab:not(.active)": "tabClick"

  initialize: ->
    @_currentTab = `undefined`
    @initFactRelationsViews()

  onRender: ->
    @showTab("supporting", @$('.tab-control>.supporting'))

  hideTabs: ->
    $tabButtons = @$(".tab-control li")
    $tabButtons.removeClass "active"

    @$(".tab-content").hide()
    @$(".tab-control > li").removeClass "tabOpened"
    @_currentTab = `undefined`

  showTab: (tab, $tabHandle)->
    @hideTabs()
    @_currentTab = tab
    $tabHandle.addClass "active"
    @$(".tab-content > .#{tab}").show()
    @$(".tab-control > li").addClass "tabOpened"
    @handleTabActions tab

  handleTabActions: (tab) ->
    mp_track "Factlink: Open tab",
      factlink_id: @model.id
      type: tab

    switch tab
      when "doubting", "supporting", "weakening" then @showFactRelations tab

  initFactRelationsViews: ->
    @supportingFactRelations = new SupportingFactRelations([],fact: @model)
    @weakeningFactRelations = new WeakeningFactRelations([],fact: @model)

  showFactRelations: (type) ->
    unless "#{type}FactRelationsView" of this
      if type == "doubting"
        relations_view = new DoubtingRelationsView(
          model: @model
          type: type
        )
      else
        relations_view = new FactRelationsView(
          model: @model
          collection: this["#{type}FactRelations"]
        )

      this["#{type}FactRelationsView"] = relations_view

      @$el.append this["#{type}FactRelationsView"].render().el

    @$(".tab-content.#{type}").show()
    this["#{type}FactRelationsView"].fetch() unless type == "doubting"

  tabClick: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $target = $(e.target).closest("li")
    tab = $target.attr("class").split(" ")[0]
    if tab is @_currentTab
      @hideTabs()
    else
      @showTab(tab, $target)
