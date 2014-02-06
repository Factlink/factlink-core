class window.AutoCompleteSearchListView extends Backbone.Factlink.SteppableView
  template: "auto_complete/search_list"

  itemViewContainer: 'ul'

  className: 'auto-complete-search-list'

  itemViewOptions: => query: '' # @model.get('text')

  constructor: ->
    super

    @on 'render', -> @$el.preventScrollPropagation()

  showEmptyView: -> @$el.hide()
  closeEmptyView: -> @$el.show()
