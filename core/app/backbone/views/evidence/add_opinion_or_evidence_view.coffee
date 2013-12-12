class window.AddOpinionOrEvidenceView extends Backbone.Marionette.Layout
  className: 'add-opinion-or-evidence evidence-centered'
  template: 'evidence/add_opinion_or_evidence'

  regions:
    formRegion: '.js-form-region'

  onRender: ->
    @formRegion.show new AddEvidenceFormView collection: @collection
