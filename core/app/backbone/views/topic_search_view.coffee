class TopicSearchItemView extends Backbone.Marionette.ItemView
  className: 'list-channel'
  template: "topics/topic_search"
  templateHelpers: ->
    created_by: @model.user().toJSON()

class window.TopicSearchView extends Backbone.Marionette.CollectionView
  className: "topic-search-result search-result"
  itemView: TopicSearchItemView
  initialize: ->
    @collection = new ChannelList(@model.get('channels'))
