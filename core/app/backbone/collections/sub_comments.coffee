class window.SubComments extends Backbone.Collection
  model: SubComment

  initialize: (models, options) -> @parentModel = options.parentModel

  url: -> @parentModel.url() + '/sub_comments'
