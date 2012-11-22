#= require ./../evidence/evidence_view

class CommentPopoverView extends EvidencePopoverView
  delete_message: 'Remove this comment'


class CommentView extends Backbone.Marionette.ItemView
  className: 'evidence-content'
  template:  'comments/comment'

  templateHelpers: =>
    creator: @model.creator().toJSON()


class window.CommentEvidenceView extends EvidenceBaseView

  onRender: ->
    @userAvatarRegion.show new EvidenceUserAvatarView model: @model
    @activityRegion.show   new EvidenceActivityView model: @model

    @mainRegion.show new CommentView model: @model

    if @model.can_destroy()
      @popoverRegion.show new CommentPopoverView model: @model


class window.CommentsListView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  className: 'comments-listing'
  itemView: CommentEvidenceView
