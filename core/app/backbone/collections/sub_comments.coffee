class window.SubComments extends Backbone.Collection
  model: SubComment

  initialize: (models, options) ->
    @parentModel = options.parentModel

    @on 'add', => @parentModel.set 'can_destroy?', false
    @on 'remove', => @parentModel.fetch if @length <= 0
    @on 'add remove reset', => @parentModel.set 'sub_comments_count', @length

  url: -> @parentModel.url() + '/sub_comments'
