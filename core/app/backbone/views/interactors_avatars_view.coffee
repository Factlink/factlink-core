class NDPInteractorAvatarView extends Backbone.Marionette.Layout
  tagName: 'li'
  className: 'interactor-avatar user-avatar'
  template: 'fact_relations/interactor_avatar'

  templateHelpers: => user: new User(@model).toJSON()

class window.NDPInteractorsAvatarView extends Backbone.Marionette.CompositeView
  template: "fact_relations/ndp_interactors_avatars"
  itemView: NDPInteractorAvatarView
  # emptyView: InteractorEmptyView

  itemViewContainer: ".js-interactor-avatars-collection"

  events:
    'click .showAll' : 'showAll'

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
    multiplicity = if @collection.totalRecords > 1 then 'plural' else 'singular'
    translation = switch @collection.type
      when 'weakening' then "fact_disbelieve_past_#{multiplicity}_action"
      when 'supporting' then "fact_believe_past_#{multiplicity}_action"
      when 'doubting' then "fact_doubt_past_#{multiplicity}_action"

    past_action: Factlink.Global.t[translation]

  showAll: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @collection.howManyPer(1000000)
    @fetch()
