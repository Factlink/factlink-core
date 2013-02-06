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
    bottomRegion:      '.evidence-bottom-region'
    subCommentsRegion: '.evidence-sub-comments-region'

  initialize: ->
    @on 'render', @evidenceBaseOnRender, @

  setPopover: ->
    if Factlink.Global.signed_in
      updatePopover = =>
        if @model.can_destroy()
          popoverView = new EvidencePopoverView
                              model: @model,
                              delete_message: @delete_message
          @popoverRegion.show popoverView
        else
          @popoverRegion.close()

      updatePopover()
      @bindTo @model, 'change', updatePopover

  evidenceBaseOnRender: ->
    @userAvatarRegion.show new EvidenceUserAvatarView model: @model
    @activityRegion.show   new EvidenceActivityView model: @model, verb: @activityVerb

    if Factlink.Global.signed_in
      voteRelevanceView = new InteractiveVoteUpDownView model: @model
    else
      voteRelevanceView = new VoteUpDownView model: @model

    @voteRegion.show voteRelevanceView
    @bottomRegion.show @evidenceBottomView()

    @mainRegion.show new @mainView model: @model
    @setPopover()

  evidenceBottomView: ->
    unless @_evidenceBottomView
      @_evidenceBottomView = new EvidenceBottomView model: @model
      @bindTo @_evidenceBottomView, 'toggleSubCommentsList', @toggleSubCommentsList, @
    @_evidenceBottomView

  toggleSubCommentsList: ->
    if @subCommentsOpen
      @subCommentsOpen = false
      @subCommentsRegion.close()
    else
      @subCommentsOpen = true
      @subCommentsRegion.show new SubCommentsListView
        collection: new SubComments([], parentModel: @model)

  highlight: ->
    @$el.animate
      'background-color': '#ffffe1'
    ,
      duration: 500
      complete: ->
        $(this).animate
          'background-color': '#ffffff'
        , 2500


class EvidenceUserAvatarView extends Backbone.Marionette.ItemView
  className: 'evidence-user-avatar'
  template:  'evidence/user_avatar'

  templateHelpers: => creator: @model.creator().toJSON()


class EvidenceActivityView extends Backbone.Marionette.ItemView
  className: 'evidence-activity'
  template:  'evidence/activity'

  initialize: -> @bindTo @model, 'change', @render, @

  templateHelpers: =>
    creator: @model.creator().toJSON()
    verb: @options.verb


ViewWithPopover = extendWithPopover(Backbone.Marionette.ItemView)

class EvidencePopoverView extends ViewWithPopover
  template: 'evidence/popover'

  initialize: (options)->
    @delete_message = options.delete_message

  templateHelpers: =>
    delete_message: @delete_message

  events:
    'click li.delete': 'destroy'

  popover: [
    selector: '.evidence-popover-arrow'
    popoverSelector: '.evidence-popover'
  ]

  destroy: -> @model.destroy wait: true
