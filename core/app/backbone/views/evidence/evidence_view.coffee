class window.EvidenceBaseView extends Backbone.Marionette.Layout
  tagName:   'li'
  className: 'evidence-item'
  template:  'evidence/base'

  regions:
    voteRegion:        '.evidence-vote-region'
    userAvatarRegion:  '.evidence-user-avatar-region'
    activityRegion:    '.evidence-activity-region'
    mainRegion:        '.evidence-main-region'
    popoverRegion:     '.evidence-popover-region'
    subCommentsRegion: '.evidence-sub-comments-region'

  setPopover: (popoverClass) ->
    updatePopover = =>
      if @model.can_destroy()
        @popoverRegion.show new popoverClass model: @model

    updatePopover()
    @bindTo @model, 'change', updatePopover

  showSubCommentsView: ->
    @subCommentsRegion.show new SubCommentsView model: @model

class window.EvidenceUserAvatarView extends Backbone.Marionette.ItemView
  className: 'evidence-user-avatar'
  template:  'evidence/user_avatar'

  templateHelpers: => creator: @model.creator().toJSON()


class window.EvidenceActivityView extends Backbone.Marionette.ItemView
  className: 'evidence-activity'
  template:  'evidence/activity'

  initialize: -> @bindTo @model, 'change', @render, @

  templateHelpers: =>
    creator: @model.creator().toJSON()
    verb: @options.verb


class window.VoteUpDownView extends Backbone.Marionette.ItemView
  className: "evidence-actions"

  template: "evidence/vote_up_down"

  events:
    "click .weakening": "disbelieve"
    "click .supporting": "believe"

  initialize: ->
    @bindTo @model, "change", @render, @

  hideTooltips: ->
    @$(".weakening").tooltip "hide"
    @$(".supporting").tooltip "hide"

  onRender: ->
    @$(".supporting").tooltip
      title: "This is relevant"

    @$(".weakening").tooltip
      title: "This is not relevant"
      placement: "bottom"

  onBeforeClose: ->
    @$(".weakening").tooltip "destroy"
    @$(".supporting").tooltip "destroy"

  disbelieve: ->
    @hideTooltips()
    @model.disbelieve()

  believe: ->
    @hideTooltips()
    @model.believe()


ViewWithPopover = extendWithPopover(Backbone.Marionette.ItemView)

class window.EvidencePopoverView extends ViewWithPopover
  template: 'evidence/popover'

  templateHelpers: =>
    delete_message: @delete_message

  events:
    'click li.delete': 'destroy'

  popover: [
    selector: '.evidence-popover-arrow'
    popoverSelector: '.evidence-popover'
  ]

  destroy: -> @model.destroy()
