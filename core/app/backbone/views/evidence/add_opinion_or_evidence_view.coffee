class window.AddOpinionOrEvidenceView extends Backbone.Marionette.Layout
  className: 'add-opinion-or-evidence evidence-centered'
  template: 'evidence/add_opinion_or_evidence'

  regions:
    formRegion: '.js-form-region'

  ui:
    formRegion: '.js-form-region'
    buttons: '.js-buttons'

  events:
    'click .js-believes': -> @_factVotes.saveCurrentUserOpinion 'believes'
    'click .js-disbelieves': -> @_factVotes.saveCurrentUserOpinion 'disbelieves'
    'click .js-comment': -> @_addComment = true; @_updateShowingForm()

  onRender: ->
    @_addComment = false
    @_factVotes = @collection.fact.getFactVotes()
    @listenTo @_factVotes, 'change:current_user_opinion', @_updateShowingForm
    @formRegion.show new AddEvidenceFormView collection: @collection
    @_updateShowingForm()

  _updateShowingForm: ->
    showForm = (@_addComment || @_factVotes.get('current_user_opinion') != 'no_vote')

    @ui.formRegion.toggle showForm
    @ui.buttons.toggle !showForm
