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
        alert "Something went wrong while adding the evidence, sorry"
        @collection.remove model
        @model.set text: prevText


class AddCommentView extends Backbone.Marionette.ItemView
  events:
    "click .submit": 'submit'

  template:
    text: """
      Here you should input a comment for "{{ displaystring }}":
      <input type="text">
      <input type="submit" class="submit btn btn-primary" value="Add comment">
    """
  submit: ->
    # @disableSubmit()
    alert("adding new comment")

  templateHelpers: =>
    displaystring: @model.get('displaystring')


class window.AddEvidenceView extends Backbone.Marionette.Layout
  template:
    text: """
      <div class='input-region'></div>
    """

  regions:
    inputRegion: '.input-region'

  # TODO remove on updating marionette
  initialEvents: -> # don't rerender on collection change

  initialize: ->
    @viewCache = null

  onRender: ->
    @inputRegion.show new AutoCompleteFactRelationsView
      collection: @collection

    # Render new view in inputRegion - prevent merge conflict
    @inputRegion.show new AddCommentView model: @collection.fact
