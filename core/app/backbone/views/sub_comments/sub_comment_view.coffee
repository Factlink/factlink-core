class SubCommentPoparrowView extends Backbone.Factlink.PoparrowView
  template: 'sub_comments/poparrow'

  initialize: (options)->
    @delete_message = options.delete_message

  templateHelpers: =>
    delete_message: @delete_message

  events:
    'click li.delete': 'destroy'

  destroy: -> @model.destroy wait: true

class BaseSubCommentView extends Backbone.Marionette.Layout
  template: 'sub_comments/sub_comment'

  regions:
    poparrowRegion: '.js-region-evidence-sub-comment-poparrow'

  initialize: ->
    @listenTo @model, 'change', @render


class window.SubCommentView extends BaseSubCommentView
  className: 'evidence-sub-comment'

  templateHelpers: => creator: @model.creator().toJSON()

  onRender: ->
    @setPoparrow() if Factlink.Global.signed_in

  setPoparrow: ->
    if @model.can_destroy()
      poparrowView = new SubCommentPoparrowView
                          model: @model,
                          delete_message: 'Remove this comment'
      @poparrowRegion.show poparrowView


class window.NDPSubCommentView extends BaseSubCommentView
  template: 'sub_comments/ndp_sub_comment'
