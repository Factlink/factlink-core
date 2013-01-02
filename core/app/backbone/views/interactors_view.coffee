class InteractorEmptyView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: "fact_relations/interactor_empty"

  appendSeparator: (text)-> @$el.append text

class InteractorView extends Backbone.Marionette.Layout
  tagName: 'span'
  template: "fact_relations/interactor"

  appendSeparator: (text)-> @$('a').after text

class window.InteractorsView extends Backbone.Marionette.CompositeView
  template: "fact_relations/interactors"
  emptyView: InteractorEmptyView
  itemView: InteractorView
  itemViewContainer: "span"
  events:
    'click a.showAll' : 'showAll'

  initialize: (options) ->
    @model = new Backbone.Model
    @fetch()

  fetch: ->
    @collection.fetch success: =>
      @model.set
        numberNotDisplayed: @collection.totalRecords - @collection.length
        multipleNotDisplayed: (@collection.totalRecords - @collection.length)>1
      @render()

  templateHelpers: =>
    translation = switch @collection.type
      when 'weakening' then 'fact_disbelieve_past_action'
      when 'supporting' then 'fact_believe_past_action'
      when 'doubting' then 'fact_doubt_past_action'

    past_action: Factlink.Global.t[translation]

  showAll: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @collection.howManyPer(1000000)
    @fetch()

  insertItemSeparator: (itemView, index) ->
    sep = Backbone.Factlink.listSeparator(@collection.totalRecords, @collection.length, index)
    itemView.appendSeparator(sep) if sep?

  appendHtml: (collectionView, itemView, index) =>
    @insertItemSeparator itemView, index
    super(collectionView, itemView, index)
