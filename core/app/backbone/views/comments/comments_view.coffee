#= require ./../evidence/evidence_view

class CommentPopoverView extends EvidencePopoverView
  delete_message: 'Remove this comment'


class CommentView extends Backbone.Marionette.ItemView
  className: 'evidence-content'
  template:  'comments/comment'

  initialize: ->
    @trunk8Init 5, '.js-content', '.less'

_.extend(CommentView.prototype, Backbone.Factlink.Trunk8MoreLessMixin)

class window.CommentEvidenceView extends EvidenceBaseView
  onRender: ->
    @userAvatarRegion.show new EvidenceUserAvatarView model: @model
    @activityRegion.show   new EvidenceActivityView model: @model, verb: 'commented'

    @mainRegion.show new CommentView model: @model

    @voteRegion.show new VoteUpDownView model: @model
    @setPopover CommentPopoverView


class window.CommentsListView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  className: 'comments-listing'
  itemView: CommentEvidenceView
