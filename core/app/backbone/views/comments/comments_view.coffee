#= require ./../evidence/evidence_view
#= require ./../evidence/vote_up_down_view

class CommentView extends Backbone.Marionette.ItemView
  _.extend @prototype, Backbone.Factlink.Trunk8MoreLessMixin

  className: 'evidence-content'
  template:  'comments/comment'

  onRender: ->
    @trunk8Init 5, '.js-content', '.less'


class VoteUpDownCommentView extends VoteUpDownView

  current_opinion: -> @model.get('current_user_opinion')

  on_up_vote: ->
    if @model.isBelieving()
      @model.removeOpinion()
    else
      @model.believe()

  on_down_vote: ->
    if @model.isDisBelieving()
      @model.removeOpinion()
    else
      @model.disbelieve()

class window.CommentEvidenceView extends EvidenceBaseView
  mainView: CommentView
  voteView: VoteUpDownCommentView
  delete_message: 'Remove this comment'

