class window.SubCommentView extends Backbone.Marionette.Layout
  template: 'sub_comments/sub_comment'
  className: 'evidence-sub-comment'

  regions:
    poparrowRegion: '.js-region-evidence-sub-comment-poparrow'

  templateHelpers: => creator: @model.creator().toJSON()

  initialize: ->
    @listenTo @model, 'change', @render

  onRender: ->
    @setPoparrow() if Factlink.Global.signed_in

  setPoparrow: ->
    if @model.can_destroy()
      poparrowView = new SubCommentPoparrowView
                          model: @model,
                          delete_message: 'Remove this comment'
      @poparrowRegion.show poparrowView


class window.NDPSubCommentView extends Backbone.Marionette.Layout
  template: 'sub_comments/ndp_sub_comment'

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
