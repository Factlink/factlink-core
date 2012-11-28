#= require ./../evidence/evidence_view

class CommentPopoverView extends EvidencePopoverView
  delete_message: 'Remove this comment'


class CommentView extends Backbone.Marionette.ItemView
  className: 'evidence-content'
  template:  'comments/comment'

  showLines: 5

  events:
    "click a.more": "showCompleteDisplaystring"
    "click a.less": "hideCompleteDisplaystring"

  onRender: ->
    sometimeWhen(
      => @$el.is ":visible"
      ,
      => @truncateText()
    )

  truncateText: ->
    @$('.js-content').trunk8
      fill: " <a class=\"more\">(more)</a>"
      lines: @showLines

  showCompleteDisplaystring: (e) ->
    @$('.js-content').trunk8 lines: 199
    @$('.less').show()
    e.stopPropagation()

  hideCompleteDisplaystring: (e) ->
    @$('.js-content').trunk8 lines: @showLines
    @$('.less').hide()
    e.stopPropagation()

class window.CommentEvidenceView extends EvidenceBaseView

  onRender: ->
    @userAvatarRegion.show new EvidenceUserAvatarView model: @model
    @activityRegion.show   new EvidenceActivityView model: @model

    @mainRegion.show new CommentView model: @model

    @setPopover CommentPopoverView


class window.CommentsListView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  className: 'comments-listing'
  itemView: CommentEvidenceView
