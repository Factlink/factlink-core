#= require ../auto_complete/search_view

class window.AutoCompleteFactRelationsView extends AutoCompleteSearchView
  className: "auto-complete auto-complete-fact-relations"

  events:
    "click div.auto-complete-search-list": "addCurrent"
    "click .fact-relation-post": "addNew"

  regions:
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.auto-complete-input-container'

  template:
    text: """
      <div class="auto-complete-input-container"></div>
      <div class="auto-complete-search-list-container"></div>
      <button class="btn btn-primary fact-relation-post">Post Factlink</button>
    """

  initialize: ->
    @initializeChildViews
      filter_on: 'id'
      search_list_view: (options)-> new AutoCompleteSearchFactRelationsView(options)
      search_collection: => new FactRelationSearchResults([], fact_id: @collection.fact.id)
      placeholder: @placeholder()

  placeholder: ->
    if @collection.type == "supporting"
      "The Factlink above is true because:"
    else
      "The Factlink above is false because:"

  addNew: ->
    text = @model.get('text')

    @createFactRelation
      displaystring: text
      fact_base: new Fact(displaystring: text).toJSON()
      fact_relation_type: @collection.type
      created_by: currentUser.toJSON()
      fact_relation_authority: '1.0'

  addCurrent: ->
    selected_result = @_search_list_view.currentActiveModel()

    @createFactRelation
      evidence_id: selected_result.id
      fact_base: selected_result.toJSON()
      fact_relation_type: @collection.type
      created_by: currentUser.toJSON()
      fact_relation_authority: '1.0'

  createFactRelation: (attributes) ->
    prevText = @model.get 'text'
    @model.set text: ''
    model = @collection.create attributes,
      error: =>
        @collection.remove model
        @model.set text: prevText
        alert "Something went wrong while adding the evidence, sorry"

    @trigger 'click'

class Henk extends Backbone.Marionette.Region
  initialize: ->
    @cacheViews = {}
    @viewConstructors = {}
    @on 'close', @onClose, @

  defineViews: (viewConstructors) ->
    @viewConstructors = viewConstructors

  createView: (name) ->
    @viewConstructors[name]()

  getView: (name) ->
    @cacheViews[name] ?= @createView(name)

  detach: ->
    @currentView?.$el.detach()
    delete @currentView

  switchTo: (name) ->
    @detach()
    view = @getView(name)
    @show(view)

  onClose: ->
    for name, view of @cacheViews
      view.close()
    delete @cacheViews
    delete @viewConstructors

class PreviewView extends Backbone.Marionette.ItemView
  template:
    text: """
      hoi
    """
  events:
    'click': 'onClick'

  onClick: ->
    @trigger 'click'



class AddCommentView extends Backbone.Marionette.ItemView
  events:
    'click .submit': 'submit'

  template: 'comments/add_comment'
  submit: ->
    # @disableSubmit()

  templateHelpers: =>
    displaystring: @model.get('displaystring')



class window.AddEvidenceView extends Backbone.Marionette.Layout
  template:
    text: """
      <div class='input-region'></div>
    """

  regions:
    inputRegion:
      selector: '.input-region'
      regionType: Henk

  # TODO remove on updating marionette
  initialEvents: -> # don't rerender on collection change

  # TODO: remove this when updating Marionette
  # In the current version the order is the other way around
  constructor: ->
    this.initializeRegions()
    Backbone.Marionette.ItemView.apply(this, arguments)

  initialize: ->
    @inputRegion.defineViews
      search_view: => @searchView()
      preview_view: => @previewView()
      add_comment_view: => @addCommentView()

  onRender: ->
    @inputRegion.switchTo 'search_view'

  searchView: ->
    searchView = new AutoCompleteFactRelationsView
      collection: @collection
    # @bindTo searchView, 'click', =>
      # @inputRegion.switchTo 'preview_view'
    searchView

  previewView: ->
    previewView = new PreviewView
    @bindTo previewView, 'click', =>
      @inputRegion.switchTo 'search_view'
    previewView

  addCommentView: ->
    new AddCommentView model: @collection.fact

  onClose: ->
    @_searchView?.close()
    @_previewView?.close()
