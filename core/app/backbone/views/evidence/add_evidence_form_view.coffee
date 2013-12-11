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
    @_searchView = new AutoCompleteFactRelationsView
      collection: @_filtered_facts()
      addToCollection: @collection
      fact_id: @collection.fact.id
      argumentTypeModel: @_argumentTypeModel

    @_addCommentView ?= new AddCommentView
      addToCollection: @collection
      argumentTypeModel: @_argumentTypeModel


    @inputRegion.defineViews
      search_view: => @_searchView
      add_comment_view: => @_addCommentView

  onRender: ->
    @_argumentTypeModel = new Backbone.Model
    @_updateArgumentType()

    @listenTo @_searchView, 'switch_to_comment_view', @_switchToCommentView
    @listenTo @_addCommentView, 'switch_to_fact_relation_view', @_switchToFactRelationView

    @headingRegion.show new EvidenceishHeadingView model: currentUser
    @_switchToCommentView()

  _updateArgumentType: ->
    @_argumentTypeModel.set 'argument_type', @$('input[name=argumentType]:checked').val()

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
