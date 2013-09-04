class window.SubCommentView extends Backbone.Marionette.Layout
  template: 'sub_comments/sub_comment'

  regions:
    deleteRegion: '.js-delete-region'

  initialize: ->
    @listenTo @model, 'change', @render

  templateHelpers: =>
    showDelete: @model.can_destroy()

  onRender: ->
    if @model.can_destroy()
      @_deleteButtonView = new DeleteButtonView model: @model
      @listenTo @_deleteButtonView, 'delete', -> @model.destroy wait: true
      @deleteRegion.show @_deleteButtonView
