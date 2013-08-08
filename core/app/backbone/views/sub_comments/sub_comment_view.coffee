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
  className: 'evidence-sub-comment'

  template: 'sub_comments/sub_comment'

  initialize: ->
    @listenTo @model, 'change', @render

  setPoparrow: ->
    if @model.can_destroy()
      poparrowView = new SubCommentPoparrowView
                          model: @model,
                          delete_message: 'Remove this comment'
      @poparrowRegion.show poparrowView


class window.SubCommentView extends BaseSubCommentView
  regions:
    poparrowRegion: '.js-region-evidence-sub-comment-poparrow'

  templateHelpers: => creator: @model.creator().toJSON()

  onRender: ->
    @setPoparrow() if Factlink.Global.signed_in


class window.NDPSubCommentView extends BaseSubCommentView
  className: 'ndp-sub-comment'
  template: 'sub_comments/ndp_sub_comment'

  regions:
    headingRegion: '.js-heading-region'
    poparrowRegion: '.js-region-evidence-sub-comment-poparrow'

  onRender: ->
    @headingRegion.show new NDPEvidenceishHeadingView model: @model.creator()
    @setPoparrow() if Factlink.Global.signed_in
