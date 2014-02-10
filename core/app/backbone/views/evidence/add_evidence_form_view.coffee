class window.AddEvidenceFormView extends Backbone.Marionette.Layout
  className: 'add-evidence-form'
  template: 'evidence/add_evidence_form'

  regions:
    addCommentRegion: '.js-add-comment-region'
    searchFactsRegion: '.js-search-facts-region'

  events:
    'click .js-open-search-facts-link': '_openSearchFacts'

  ui:
    openSearchFactsLink: '.js-open-search-facts-link'

  initialize: ->
    @_addCommentView = new AddCommentView
      addToCollection: @collection
      onFocus: =>
        @$(".add-evidence-form-search-facts").show()

  onRender: ->
    @addCommentRegion.show @_addCommentView

  focus: ->
    @_addCommentView.focus()

  _openSearchFacts: ->
    @ui.openSearchFactsLink.hide()

    auto_complete_facts_view = ReactAutoCompleteFactsView
      model: new FactSearchResults [], fact_id: @collection.fact.id
      onInsert: (text) => @_addCommentView.insert text

    @searchFactsRegion.show new ReactView
      component: auto_complete_facts_view

    auto_complete_facts_view.focus()
