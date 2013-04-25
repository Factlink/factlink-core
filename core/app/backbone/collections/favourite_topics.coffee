class window.FavouriteTopics extends Backbone.Collection

  url: -> "/#{currentUser.get('username')}/favourite_topics"
