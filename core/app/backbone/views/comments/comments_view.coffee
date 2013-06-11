#= require ./../evidence/evidence_view

class CommentView extends Backbone.Marionette.ItemView
  _.extend @prototype, Backbone.Factlink.Trunk8MoreLessMixin

  className: 'evidence-content'
  template:  'comments/comment'

  onRender: ->
    @trunk8Init 5, '.js-content', '.less'


class window.CommentEvidenceView extends EvidenceBaseView
  mainView: CommentView
  delete_message: 'Remove this comment'

