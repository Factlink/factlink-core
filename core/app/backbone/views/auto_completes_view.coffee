class window.AutoCompletedChannelView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "mouseenter": "requestActivate",
    "mouseleave": "requestDeActivate"

  template: "channels/auto_completed_channel"

  initialize: ->
    @queryRegex = new RegExp(@options.query, "gi")

    @on 'activate', @activate, this
    @on 'deactivate', @deactivate, this

  templateHelpers: ->
    view = this

    highlightedTitle: -> htmlEscape(@title).replace(view.queryRegex, "<em>$&</em>")

  onRender: ->
    @$el.addClass('user-channel') if @model.existingChannelFor(currentUser)

  deactivate: -> @$el.removeClass 'active'
  activate: ->
    @$el.addClass 'active'
    @scrollIntoView()

  scrollIntoView: -> scrollIntoViewWithinContainer(@el, @$el)

class window.AutoCompletesView extends Backbone.Factlink.SteppableView
  template: "channels/auto_completes"

  itemViewContainer: 'ul.existing-container'
  itemView: AutoCompletedChannelView

  className: 'auto_complete'

  itemViewOptions: => query: @model.get('text')

  initialize: -> @on 'composite:collection:rendered', => @setActiveView 0

  onRender: -> @$(@itemViewContainer).preventScrollPropagation()

  showEmptyView: -> @$el.hide()
  closeEmptyView: -> @$el.show()

  appendHtml: (collectionView, itemView, index)->
     if itemView.model.get('new')
       @$('.new-container').append(itemView.el)
     else
       super collectionView, itemView, index
