class window.FavouriteTopics extends Backbone.Collection
  _.extend @prototype, Backbone.Factlink.ActivatableCollectionMixin

  model: Topic
  comparator: 'slug_title'

  initialize: (models, options) ->
    @user = options.user

  url: -> "/#{@user.get('username')}/favourite_topics"
