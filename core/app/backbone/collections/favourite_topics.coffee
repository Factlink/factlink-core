class window.FavouriteTopics extends Backbone.Collection
  _.extend @prototype, Backbone.Factlink.ActivatableCollectionMixin

  model: Topic

  # TODO: when updating Backbone this can just be a string 'slug_title'
  comparator: (model) -> model.get('slug_title')

  initialize: (models, options) ->
    @user = options.user

  url: -> "/#{@user.get('username')}/favourite_topics"
