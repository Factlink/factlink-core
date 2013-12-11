class window.AddEvidenceFormView extends Backbone.Marionette.Layout
  className: 'add-evidence-form evidence-centered'
  template: 'evidence/add_evidence_form'

  regions:
    headingRegion: '.js-heading-region'
    inputRegion:
      selector: '.input-region'
      regionType: Factlink.DetachableViewsRegion

  events:
    'change input[name=argumentType]': '_updateArgumentType'
    'click .js-switch-to-factlink': '_switchToAddFactRelationView'
    'click .js-switch-to-comment': '_switchToAddCommentView'

  ui:
    switchToFactlink: '.js-switch-to-factlink'
    switchToComment: '.js-switch-to-comment'

  initialize: ->
    @_argumentTypeModel = new Backbone.Model

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
    @_updateArgumentType()
    @headingRegion.show new EvidenceishHeadingView model: currentUser
    @_switchToAddCommentView()

  _updateArgumentType: ->
    @_argumentTypeModel.set 'argument_type', @$('input[name=argumentType]:checked').val()

  _switchToAddCommentView: ->
    @ui.switchToFactlink.show()
    @ui.switchToComment.hide()
    @inputRegion.switchTo 'add_comment_view'
    mp_track "Evidence: Switching to comment"

  _switchToAddFactRelationView: ->
    @ui.switchToFactlink.hide()
    @ui.switchToComment.show()
    @inputRegion.switchTo 'search_view'
    mp_track "Evidence: Switching to FactRelation"

  _filtered_facts: ->
    fact_relations_masquerading_as_facts = @_collectionUtils().map new Backbone.Collection,
      @collection, (model) -> new Fact model.get('from_fact')

    @_collectionUtils().union new Backbone.Collection, fact_relations_masquerading_as_facts,
      new Backbone.Collection [@collection.fact.clone()]

  _collectionUtils: ->
    @_____collectionUtils ?= new CollectionUtils this
