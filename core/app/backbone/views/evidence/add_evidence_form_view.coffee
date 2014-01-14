class window.AddEvidenceFormView extends Backbone.Marionette.Layout
  className: 'add-evidence-form'
  template: 'evidence/add_evidence_form'

  regions:
    addCommentRegion: '.js-add-comment-region'
    searchFactsRegion: '.js-search-facts-region'

  events:
    'change input[name=argumentType]': '_updateArgumentType'
    'click .js-open-search-facts-link': '_openSearchFacts'
    'click .js-change-type': '_showTypeSelector'

  ui:
    question: '.js-question'
    questionContainer: '.js-question-container'
    typeSelector: '.js-type-selector'
    openSearchFactsLink: '.js-open-search-facts-link'

  initialize: ->
    @_argumentTypeModel = new Backbone.Model
    @_factVotes = @collection.fact.getVotes()
    @listenTo @_factVotes, 'reset change add remove', @_setArgumentTypeToOpinion

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
    opinion = @_factVotes.opinion_for_current_user()
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
    @ui.openSearchFactsLink.hide()

    auto_complete_facts_view = new AutoCompleteFactsView
      collection: new Backbone.Collection
      fact_id: @collection.fact.id
      argumentTypeModel: @_argumentTypeModel

    @listenTo auto_complete_facts_view, 'insert', (text) -> @_addCommentView.insert text

    @searchFactsRegion.show auto_complete_facts_view
