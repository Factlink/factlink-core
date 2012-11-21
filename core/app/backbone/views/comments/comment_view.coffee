#= require ./../evidence/evidence_view

class window.CommentEvidenceView extends EvidenceBaseView

  onRender: ->
    @userAvatarRegion.show new EvidenceUserAvatarView model: @model
    @activityRegion.show   new EvidenceActivityView model: @model

    # @voteRegion.show new VoteUpDownView model: @model
    @mainRegion.show new CommentView model: @model

    if @model.get('can_destroy?')
      @popoverRegion.show new FactRelationPopoverView model: @model


class window.CommentView extends Backbone.Marionette.ItemView

  template:  'comments/comment'

  templateHelpers: =>
    creator: @model.creator().toJSON()
