#= require ./../evidence/evidence_view

class CommentView extends Backbone.Marionette.ItemView
  className: 'evidence-content'
  template:  'comments/comment'

  initialize: ->
    @trunk8Init 5, '.js-content', '.less'

_.extend(CommentView.prototype, Backbone.Factlink.Trunk8MoreLessMixin)

class window.CommentEvidenceView extends EvidenceBaseView
  activityVerb: 'commented'
  mainView: CommentView
  delete_message: 'Remove this comment'

class window.CommentsListView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  className: 'comments-listing'
  itemView: CommentEvidenceView
