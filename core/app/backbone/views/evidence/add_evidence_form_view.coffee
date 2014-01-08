class window.AddEvidenceFormView extends Backbone.Marionette.Layout
  className: 'add-evidence-form'
  template: 'evidence/add_evidence_form'

  regions:
    inputRegion:
      selector: '.input-region'
      regionType: Factlink.DetachableViewsRegion

  events:
    'change input[name=argumentType]': '_updateArgumentType'
    'click .js-switch-to-factlink': '_switchToAddFactRelationView'
    'click .js-switch-to-comment': '_switchToAddCommentView'
    'click .js-change-type': '_showTypeSelector'

  ui:
    switchToFactlink: '.js-switch-to-factlink'
    switchToComment: '.js-switch-to-comment'
    question: '.js-question'
    questionContainer: '.js-question-container'
    typeSelector: '.js-type-selector'

  initialize: ->
    @_argumentTypeModel = new Backbone.Model
    @_factTally = @collection.fact.getFactTally()
    @listenTo @_factTally, 'change:current_user_opinion', @_setArgumentTypeToOpinion

    @inputRegion.defineViews
      search_view: => new AutoCompleteFactRelationsView
        collection: @_filtered_facts()
        addToCollection: @collection
        fact_id: @collection.fact.id
        argumentTypeModel: @_argumentTypeModel
      add_comment_view: => new AddCommentView
        addToCollection: @collection
        argumentTypeModel: @_argumentTypeModel


  onRender: ->
    @_setArgumentTypeToOpinion()
    @_switchToAddCommentView()

  focus: ->
    @_switchToAddCommentView()

  _showQuestion: ->
    @ui.questionContainer.show()
    @ui.typeSelector.hide()

  _showTypeSelector: ->
    @ui.typeSelector.show()
    @ui.questionContainer.hide()

  _updateArgumentType: ->
    @_argumentTypeModel.set 'argument_type', @$('input[name=argumentType]:checked').val()
    @_updateQuestion()

  _setArgumentTypeToOpinion: ->
    opinion = @_factTally.get('current_user_opinion')
    opinion = 'doubts' if opinion == 'no_vote'

    @$("input[name=argumentType][value=#{opinion}]").prop('checked', true)
    @_updateArgumentType()
    @_showQuestion()

  _updateQuestion: ->
    @ui.question.text switch @_argumentTypeModel.get('argument_type')
      when 'believes'
        "Why do you #{Factlink.Global.t.fact_believe_opinion}?"
      when 'disbelieves'
        "Why do you #{Factlink.Global.t.fact_disbelieve_opinion}?"
      when 'doubts'
        "What do you think?"
      else
        ''

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
