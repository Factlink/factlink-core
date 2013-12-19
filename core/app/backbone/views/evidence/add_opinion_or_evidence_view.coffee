class window.AddOpinionOrEvidenceView extends Backbone.Marionette.Layout
  className: 'add-opinion-or-evidence'
  template: 'evidence/add_opinion_or_evidence'

  regions:
    formRegion: '.js-form-region'

  ui:
    buttons: '.js-buttons'

  events:
    'click .js-believes': -> @_factVotes.clickCurrentUserOpinion 'believes'
    'click .js-disbelieves': -> @_factVotes.clickCurrentUserOpinion 'disbelieves'
    'click .js-doubts': -> @_factVotes.clickCurrentUserOpinion 'doubts'

  onRender: ->
    @_factVotes = @collection.fact.getFactVotes()
    @listenTo @_factVotes, 'change:current_user_opinion', @_updateForm
    @_updateForm()

  _updateForm: ->
    return if @formRegion.currentView?
    return if @_factVotes.get('current_user_opinion') == 'no_vote'

    @formRegion.show new AddEvidenceFormView collection: @collection
    @ui.buttons.hide()
