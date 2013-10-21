class window.CreatedFacts extends Backbone.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp

  model: Fact

  initialize: (models, options) -> @user = options.user

  url: ->  '/' + @user.get('username') + '/created_facts'
