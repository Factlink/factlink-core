class window.AddEvidenceFormView extends Backbone.Marionette.Layout
  className: 'add-evidence-form'
  template: 'evidence/add_evidence_form'

  regions:
    addCommentRegion: '.js-add-comment-region'
    searchFactsRegion: '.js-search-facts-region'

  events:
    'change input[name=argumentType]': '_updateArgumentType'
    'click .js-open-search-facts': '_openSearchFacts'
    'click .js-change-type': '_showTypeSelector'

  ui:
    question: '.js-question'
    questionContainer: '.js-question-container'
    typeSelector: '.js-type-selector'
    openSearchFacts: '.js-open-search-facts'

  initialize: ->
    @_argumentTypeModel = new Backbone.Model
    @_factTally = @collection.fact.getFactTally()
    @listenTo @_factTally, 'change:current_user_opinion', @_setArgumentTypeToOpinion

    @_addCommentView = new AddCommentView
      addToCollection: @collection
      argumentTypeModel: @_argumentTypeModel

  onRender: ->
    @addCommentRegion.show @_addCommentView

    @_setArgumentTypeToOpinion()

  focus: ->
    @_addCommentView.focus()

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

  _openSearchFacts: ->
    @ui.openSearchFacts.hide()

    @searchFactsRegion.show new AutoCompleteFactsView
      collection: @_filtered_facts()
      addToCollection: @collection
      fact_id: @collection.fact.id
      argumentTypeModel: @_argumentTypeModel

  _filtered_facts: ->
    fact_relations_masquerading_as_facts = @_collectionUtils().map new Backbone.Collection,
      @collection, (model) -> new Fact model.get('from_fact')

    @_collectionUtils().union new Backbone.Collection, fact_relations_masquerading_as_facts,
      new Backbone.Collection [@collection.fact.clone()]

  _collectionUtils: ->
    @_____collectionUtils ?= new CollectionUtils this
