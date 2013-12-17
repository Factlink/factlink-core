class window.AddOpinionOrEvidenceView extends Backbone.Marionette.Layout
  className: 'add-opinion-or-evidence'
  template: 'evidence/add_opinion_or_evidence'

  regions:
    formRegion: '.js-form-region'

  ui:
    buttons: '.js-buttons'

  events:
    'click .js-believes': -> @_factVotes.saveCurrentUserOpinion 'believes'
    'click .js-disbelieves': -> @_factVotes.saveCurrentUserOpinion 'disbelieves'
    'click .js-comment': '_showForm'

  onRender: ->
    @_factVotes = @collection.fact.getFactVotes()
    @listenTo @_factVotes, 'change:current_user_opinion', @_showFormIfVoted
    @_showFormIfVoted()

  _showFormIfVoted: ->
    @_showForm() unless @_factVotes.get('current_user_opinion') == 'no_vote'

  _showForm: ->
    return if @formRegion.currentView?

    @formRegion.show new AddEvidenceFormView collection: @collection
    @ui.buttons.hide()
