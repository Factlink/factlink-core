class SubCommentPopoverView extends Backbone.Factlink.PopoverView
  template: 'sub_comments/popover'

  initialize: (options)->
    @delete_message = options.delete_message

  templateHelpers: =>
    delete_message: @delete_message

  events:
    'click li.delete': 'destroy'

  popover:
    selector: '.sub-comments-popover-arrow'
    popoverSelector: '.sub-comments-popover'

  destroy: -> @model.destroy wait: true

class window.SubCommentView extends Backbone.Marionette.Layout
  className: 'evidence-sub-comment'

  template: 'sub_comments/sub_comment'

  regions:
    popoverRegion: '.js-region-evidence-sub-comment-popover'

  templateHelpers: => creator: @model.creator().toJSON()

  initialize: -> @bindTo @model, 'change', @render, @

  onRender: ->
    @setPopover() if Factlink.Global.signed_in

  setPopover: ->
    if @model.can_destroy()
      popoverView = new SubCommentPopoverView
                          model: @model,
                          delete_message: 'Remove this comment'
      @popoverRegion.show popoverView
