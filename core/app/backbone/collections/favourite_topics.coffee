class window.FavouriteTopics extends Backbone.Collection
  _.extend @prototype, Backbone.Factlink.ActivatableCollectionMixin

  model: Topic

  url: -> "/#{currentUser.get('username')}/favourite_topics"

  removeTopic: (topic) ->
    url = currentUser.favourite_topics.url()
    unfollowUrl = "#{@url()}/#{topic.get('slug_title')}"

    @remove topic

    $.ajax
      url: unfollowUrl
      type: 'delete'
