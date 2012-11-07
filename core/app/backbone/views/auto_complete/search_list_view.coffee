class window.AutoCompleteSearchListView extends Backbone.Factlink.SteppableView
  template: "auto_complete/_search_list"

  itemViewContainer: 'ul.existing-container'

  className: 'auto-complete-search-list'

  itemViewOptions: => query: @model.get('text')

  onRender: -> @$(@itemViewContainer).preventScrollPropagation()

  showEmptyView: -> @$el.hide()
  closeEmptyView: -> @$el.show()

  appendHtml: (collectionView, itemView, index)->
     if itemView.model.get('new')
       @$('.new-container').append(itemView.el)
     else
       super collectionView, itemView, index
