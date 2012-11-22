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

    @trigger 'createFactRelation', new FactRelation
      displaystring: text
      fact_base: new Fact(displaystring: text).toJSON()
      fact_relation_type: @collection.type
      created_by: currentUser.toJSON()
      fact_relation_authority: '1.0'

  addCurrent: ->
    selected_fact_base = @_search_list_view.currentActiveModel()

    if not selected_fact_base?
      @addNew()
      return

    @trigger 'selected', new FactRelation
      evidence_id: selected_fact_base.id
      fact_base: selected_fact_base.toJSON()
      fact_relation_type: @collection.type
      created_by: currentUser.toJSON()
      fact_relation_authority: '1.0'

class Henk extends Backbone.Marionette.Region
  initialize: ->
    @cacheViews = {}
    @cacheViewRendered = {}
    @viewConstructors = {}
    @on 'close', @onClose, @

  defineViews: (viewConstructors) ->
    @viewConstructors = viewConstructors

  _createView: (name) ->
    view = @viewConstructors[name]()
    @bindTo view, 'render', => @cacheViewRendered[name] = true
    view

  getView: (name) -> @cacheViews[name] ?= @_createView(name)

  attach: (view) ->
    @currentView = view
    @$el.html(@currentView.$el)

  detach: ->
    @currentView?.$el.detach()
    delete @currentView

  isRendered: (name) -> @cacheViewRendered[name]?

  switchTo: (name) ->
    @detach()

    view = @getView(name)

    if @isRendered(name)
      @attach view
    else
      @show view

  onClose: ->
    for name, view of @cacheViews
      view.close()
    delete @cacheViews
    delete @viewConstructors

class PreviewView extends Backbone.Marionette.Layout
  template:
    text: """
      <div class="fact-base-region"></div>
      <button class="btn btn-primary fact-relation-post js-post">Post Factlink</button>
      <a class="js-cancel" style="float: right; margin: 15px 16px 0 0; ">Cancel</a>
    """

  regions:
    factBaseRegion: '.fact-base-region'

  events:
    'click .js-cancel': 'onCancel'
    'click .js-post': 'onPost'

  onRender: ->
    @factBaseRegion.show new FactBaseView
      model: @model

  onCancel: -> @trigger 'cancel'

  onPost: -> @trigger 'createFactRelation', @model



class AddCommentView extends Backbone.Marionette.ItemView
  events:
    'click .submit': 'submit'

  template: 'comments/add_comment'

  initialize: (opts) ->
    @comments = opts.comments

  clearForm: ->
    @$('.content').val('')

  submit: ->
    content = @$('.content').val()
    comment = new Comment(content: content, created_by: currentUser)

    @comments.add comment
    comment.save {},
      success: =>
        @clearForm()
      error: =>
        @comments.remove comment
        alert 'Something went wrong while adding your comment.'



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
    @bindTo searchView, 'selected', (fact_relation) =>
      @inputRegion.getView('preview_view').model.set(fact_relation.attributes)
      @inputRegion.switchTo 'preview_view'
    @bindTo searchView, 'createFactRelation', (fact_relation) =>
      @createFactRelation(fact_relation)
    searchView

  previewView: ->
    previewView = new PreviewView
      model: new FactRelation
    @bindTo previewView, 'cancel', =>
      @inputRegion.switchTo 'search_view'
    @bindTo previewView, 'createFactRelation', (fact_relation) =>
      @createFactRelation(fact_relation)
    previewView

  addCommentView: ->
    new AddCommentView(model: @collection.fact, comments: @model.comments() )

  createFactRelation: (fact_relation)->
    @collection.add fact_relation
    @inputRegion.switchTo('search_view')
    @inputRegion.getView('search_view').model.set text: ''
    fact_relation.save {},
      error: =>
        @inputRegion.getView('search_view').model.set( text: fact_relation.get('fact_base').displaystring )
        alert('Something went wrong')
