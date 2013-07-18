class InteractorEmptyView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: "generic/text"

  templateHelpers:
    text: Factlink.Global.t.nobody.capitalize()

class InteractorNameView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'separator-list-item'
  template: 'fact_relations/interactor_name'

  templateHelpers: =>
    name: if @model.is_current_user()
            Factlink.Global.t.you.capitalize()
          else
            @model.get('name')
    show_links:
      Factlink.Global.signed_in and not @model.is_current_user()


class window.InteractingUsersNamesView extends Backbone.Marionette.CompositeView
  template: 'fact_relations/ndp_interactors_names'
  itemView: InteractorNameView
  emptyView: InteractorEmptyView
  itemViewContainer: ".js-interactors-collection"

  events:
    'click a.js-show-all' : 'show_all'

  number_of_items: 3

  initialize: (options) ->
    @collection = @model.opinionaters()
    @bindTo @collection, 'add remove reset', @render

  appendHtml: (collectionView, itemView, index) ->
    return super if @collection.length == 0 # emptyview
    super if index < @truncatedListSizes().numberToShow

  # TODO: only use one name throughout the application
  singularType: ->
    switch @collection.type
      when 'believes' then 'believe'
      when 'disbelieves' then 'disbelieve'
      when 'doubts' then 'doubt'

  templateHelpers: =>
    multiplicity = if @collection.totalRecords > 1
                     'plural'
                   else if @collection.at(0)?.is_current_user()
                     'singular_second_person'
                   else
                     'singular'
    translation = "fact_#{@singularType()}_past_#{multiplicity}_action"

    past_action: Factlink.Global.t[translation]
    numberOfOthers: @truncatedListSizes().numberOfOthers

  truncatedListSizes: ->
    truncatedListSizes @collection.totalRecords, @number_of_items

  show_all: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @number_of_items = Infinity
    @collection.howManyPer(1000000)
    @collection.fetch()
