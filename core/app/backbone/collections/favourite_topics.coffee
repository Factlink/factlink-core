class window.FavouriteTopics extends Backbone.Collection
  _.extend @prototype, Backbone.Factlink.ActivatableCollectionMixin

  model: Topic

  url: -> "/#{currentUser.get('username')}/favourite_topics"
