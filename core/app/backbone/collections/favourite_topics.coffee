class window.FavouriteTopics extends Backbone.Collection
  model: Topic

  url: -> "/#{currentUser.get('username')}/favourite_topics"
