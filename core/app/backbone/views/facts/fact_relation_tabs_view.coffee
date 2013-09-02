class window.FactRelationTabsView extends Backbone.Marionette.Layout
  template: "facts/fact_relations_tabs"

  className: "relation-tabs-view"

  events:
    "click .tab:not(.active)": "tabClick"

  regions:
    tabRegion: '.tab-content-container'

  initialize: (options)->
    if options.tab in ['weakening', 'doubting']
      @initial_tab = options.tab
    else
      @initial_tab = 'supporting'

  templateHelpers: =>
    believe_tab_name: Factlink.Global.t.fact_believe_collection_name.capitalize()
    disbelieve_tab_name: Factlink.Global.t.fact_disbelieve_collection_name.capitalize()
    doubt_tab_name: Factlink.Global.t.fact_doubt_collection_name.capitalize()
    believe_percentage: @model.opinionPercentage('believe')
    disbelieve_percentage: @model.opinionPercentage('disbelieve')
    doubt_percentage: @model.opinionPercentage('doubt')

  onRender: -> @showTab(@initial_tab)

  hideTabs: ->
    $tabButtons = @$(".tab-control li")
    $tabButtons.removeClass "active"

  showTab: (tab)->
    mp_track "Factlink: Open discussion",
      factlink_id: @model.id
      type: tab

    @hideTabs()
    $tabHandle = @$(".tab-control>.#{tab}")
    $tabHandle.addClass "active"

  tabClick: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $target = $(e.target).closest("li")
    tab = $target.attr("class").split(" ")[0]
    @showTab(tab)
