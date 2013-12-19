class window.AddOpinionOrEvidenceView extends Backbone.Marionette.Layout
  className: 'add-opinion-or-evidence'
  template: 'evidence/add_opinion_or_evidence'

  regions:
    formRegion: '.js-form-region'

  ui:
    question: '.js-question'

  onRender: ->
    @_factVotes = @collection.fact.getFactVotes()
    @listenTo @_factVotes, 'change:current_user_opinion', @_updateForm
    @_updateForm()

  _updateForm: ->
    return if @formRegion.currentView?
    return if @_factVotes.get('current_user_opinion') == 'no_vote'

    @formRegion.show new AddEvidenceFormView collection: @collection
    @ui.question.hide()
