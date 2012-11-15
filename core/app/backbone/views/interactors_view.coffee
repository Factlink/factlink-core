class InteractorEmptyView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: "fact_relations/interactor_empty"

class InteractorView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: "fact_relations/interactor"

class window.InteractorsView extends Backbone.Marionette.CompositeView
  template: "fact_relations/interactors"
  emptyView: InteractorEmptyView
  itemView: InteractorView
  itemViewContainer: "span"
  events:
    'click a' : 'showAll'

  initialize: (options) ->
    @type = @collection.type
    @model = new Backbone.Model
    @fetch()

  fetch: ->
    @collection.fetch(success: =>
      @model.set
        numberNotDisplayed: @collection.totalRecords - @collection.length
        multipleNotDisplayed: (@collection.totalRecords - @collection.length)>1

      @render() #TODO: fix this better :this render is needed
      #because the layout of the composite view doesn''t render
    )

  templateHelpers: =>
    past_action:
      switch @options.type
        when 'weakening' then 'weakened'
        when 'supporting' then 'supported'
        when 'doubting' then 'doubted'

  showAll: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @collection.howManyPer(1000000)
    @fetch()

  insertItemSeperator: (itemView, index) ->
    if index == 1 and @collection.totalRecords == @collection.length
      itemView.$el.append ' and '
    else if index != 0
      itemView.$('a').after ','

  appendHtml: (collectionView, itemView, index) =>
    @insertItemSeperator itemView, index

    collectionView.$el.prepend itemView.el
