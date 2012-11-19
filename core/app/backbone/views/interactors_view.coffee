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

  insertItemSeperator: (itemView, index) ->
    if @is_penultimate(index) and @we_see_all_interactors()
      itemView.$el.append ' and '
    else if @isnt_last(index)
      itemView.$('a').after ','

  is_penultimate: (index)-> index is @last_index - 1
  we_see_all_interactors: (index)-> @collection.totalRecords is @collection.length
  isnt_last: (index)-> index is @last_index
  last_index: -> @collection.length - 1

  appendHtml: (collectionView, itemView, index) =>
    @insertItemSeperator itemView, index
    super(collectionView, itemView, index)
