class window.AddEvidenceFormView extends Backbone.Marionette.Layout
  className: 'add-evidence-form evidence-unsure'
  template: 'evidence/add_evidence_form'

  regions:
    headingRegion: '.js-heading-region'
    inputRegion:
      selector: '.input-region'
      regionType: Factlink.DetachableViewsRegion

  events:
    'change input[name=argumentType]': '_updateArgumentType'

  initialize: ->
    @inputRegion.defineViews
      search_view: => @searchView()
      add_comment_view: => @addCommentView()

    @_argumentTypeModel = new Backbone.Model
    @_updateArgumentType()

    @listenTo @searchView(), 'switch_to_comment_view', @_switchToCommentView
    @listenTo @addCommentView(), 'switch_to_fact_relation_view', @_switchToFactRelationView

  _updateArgumentType: ->
    @_argumentTypeModel.set 'argument_type', @$('input[name=argumentType]:checked').val()

  onRender: ->
    @headingRegion.show new EvidenceishHeadingView model: currentUser
    @_switchToCommentView()

  _switchToCommentView: ->
    @inputRegion.switchTo 'add_comment_view'

  _switchToFactRelationView: ->
    @inputRegion.switchTo 'search_view'

  _filtered_facts: ->
    fact_relations_masquerading_as_facts = @_collectionUtils().map new Backbone.Collection,
      @collection, (model) -> new Fact model.get('from_fact')

    @_collectionUtils().union new Backbone.Collection, fact_relations_masquerading_as_facts,
      new Backbone.Collection [@collection.fact.clone()]

  _collectionUtils: ->
    @_____collectionUtils ?= new CollectionUtils this

  searchView: ->
    @_searchView ?= new AutoCompleteFactRelationsView
      collection: @_filtered_facts()
      addToCollection: @collection
      fact_id: @collection.fact.id
      argumentTypeModel: @_argumentTypeModel

  addCommentView: ->
    @_addCommentView ?= new AddCommentView
      addToCollection: @collection
      argumentTypeModel: @_argumentTypeModel
