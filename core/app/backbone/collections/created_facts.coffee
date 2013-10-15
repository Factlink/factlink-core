class window.CreatedFacts extends Backbone.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp

  model: Fact

  initialize: (models, opts) -> @user = opts.user

  url: ->  '/' + @user.get('username') + '/created_facts'
