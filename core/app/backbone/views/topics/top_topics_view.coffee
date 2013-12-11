class TopTopicView extends Backbone.Marionette.Layout
  template: 'users/profile/top_topic'
  className: 'top-topics-item'

  templateHelpers: =>
    position: @options.position
    topic_link: @model.topic().url()

class TopTopicsEmptyView extends Backbone.Marionette.ItemView
  template: 'users/profile/top_topics_empty'

  templateHelpers: =>
    topics: Factlink.Global.t.topics.capitalize()
    username: @options.user.get('username')
    is_current_user: @options.user.is_current_user()

class TopTopicsEmptyLoadingView extends Backbone.Factlink.EmptyLoadingView
  emptyView: TopTopicsEmptyView

class window.TopTopicsView extends Backbone.Marionette.CompositeView
  template: "users/profile/top_topics"
  className: "top-topics-container"
  itemView: TopTopicView
  emptyView: TopTopicsEmptyLoadingView
  itemViewContainer: ".top-topics"
  events:
    "click a.js-show-more": "showMoreOn"
    "click a.js-show-less": "showMoreOff"

  ui:
    showMoreLessButtons: '.js-show-more-less-buttons'

  initialize: ->
    @listenTo @collection, "add remove reset", @toggleShowMore

  templateHelpers: =>
    topics: Factlink.Global.t.topics.capitalize()

  itemViewOptions: (model) ->
    position: @collection.indexOf(model) + 1
    collection: @collection # for the emptyView
    user: @options.user

  showMoreOn:  -> @$el.addClass 'showMore'
  showMoreOff: -> @$el.removeClass 'showMore'

  onRender: ->
    @toggleShowMore()

  toggleShowMore: ->
    @ui.showMoreLessButtons.toggle (@collection.length > 5)
