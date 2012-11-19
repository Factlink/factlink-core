class InteractorEmptyView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: "fact_relations/interactor_empty"

  appendSeperator: (text)-> @$el.append text

class InteractorView extends Backbone.Marionette.Layout
  tagName: 'span'
  template: "fact_relations/interactor"

  appendSeperator: (text)-> @$('a').after text

separator = (total_length, length, index) ->
  # when we show the emptyview, the collection is
  # empty, but conceptually the length is 1
  length = 1 if length == 0

  last_index = length - 1

  is_penultimate = index == last_index - 1
  we_see_all_interactors = total_length <= length
  isnt_last = index != last_index

  if is_penultimate and we_see_all_interactors
    ' and '
  else if isnt_last
    ','
  else `undefined`

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
    sep = separator(@collection.totalRecords, @collection.length, index)
    itemView.appendSeperator(sep) if sep?

  appendHtml: (collectionView, itemView, index) =>
    @insertItemSeperator itemView, index
    super(collectionView, itemView, index)
