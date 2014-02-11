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

    recently_viewed_facts = new RecentlyViewedFacts
    recently_viewed_facts.fetch()

    react_fact_search = ReactFactSearch
      model: new FactSearchResults [],
        fact_id: @collection.fact.id
        recently_viewed_facts: recently_viewed_facts
      onInsert: (text) => @_addCommentView.insert text

    @searchFactsRegion.show new ReactView
      component: react_fact_search

    react_fact_search.focus()
