ReactSubComment = React.createBackboneClass
  render: ->
    R.span {},
      @getModel().get('formatted_comment_content')

class window.SubCommentView extends Backbone.Marionette.Layout
  template: 'sub_comments/sub_comment'

  regions:
    deleteRegion: '.js-delete-region'
    contentRegion: '.js-content-region'

  initialize: ->
    @listenTo @model, 'change', @render

  templateHelpers: =>
    showDelete: @model.can_destroy()

  onRender: ->
    if @model.can_destroy()
      reactShow @deleteRegion, ReactDeleteButton
        model: @model
        onDelete: -> @model.destroy wait: true

    reactShow @contentRegion, ReactSubComment(model: @model)
