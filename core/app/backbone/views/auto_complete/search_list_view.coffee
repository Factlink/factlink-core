class window.AutoCompleteSearchListView extends Backbone.Factlink.SteppableView
  template: "auto_complete/_search_list"

  itemViewContainer: 'ul'

  className: 'auto-complete-search-list'

  itemViewOptions: => query: @model.get('text')

  onRender: -> @$(@itemViewContainer).preventScrollPropagation()

  showEmptyView: -> @$el.hide()
  closeEmptyView: -> @$el.show()
