class window.EvidenceBaseView extends Backbone.Marionette.Layout
  tagName:   'li'
  template:  'evidence/base'

  regions:
    voteRegion:        '.evidence-vote-region'
    userAvatarRegion:  '.evidence-user-avatar-region'
    activityRegion:    '.evidence-activity-region'
    mainRegion:        '.evidence-main-region'
    poparrowRegion:    '.evidence-poparrow-region'
    bottomRegion:      '.evidence-bottom-region'
    subCommentsRegion: '.evidence-sub-comments-region'

  initialize: ->
    @on 'render', @evidenceBaseOnRender, @

  setPoparrow: ->
    updatePoparrow = =>
      if @model.can_destroy()
        poparrowView = new EvidencePoparrowView
                            model: @model,
                            delete_message: @delete_message
        @poparrowRegion.show poparrowView
      else
        @poparrowRegion.close()

    updatePoparrow()
    @listenTo @model, 'change', updatePoparrow

  evidenceBaseOnRender: ->
    @userAvatarRegion.show new AvatarView model: @model.creator()
    @activityRegion.show   new EvidenceActivityView model: @model

    voteRelevanceView = new @voteView
      model: @model,
      interactive: Factlink.Global.signed_in

    @voteRegion.show voteRelevanceView
    @bottomRegion.show @evidenceBottomView()

    @mainRegion.show new @mainView model: @model
    @setPoparrow() if Factlink.Global.signed_in

  evidenceBottomView: ->
    unless @_evidenceBottomView
      @_evidenceBottomView = new EvidenceBottomView model: @model
      @listenTo @_evidenceBottomView, 'toggleSubCommentsList', @toggleSubCommentsList
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

class EvidenceActivityView extends Backbone.Marionette.ItemView
  className: 'evidence-activity'
  template:  'evidence/activity'

  initialize: -> @listenTo @model, 'change', @render, @

  templateHelpers: =>
    creator: @model.creator().toJSON()


class EvidencePoparrowView extends Backbone.Factlink.PoparrowView
  template: 'evidence/poparrow'

  initialize: (options)->
    @delete_message = options.delete_message

  templateHelpers: =>
    delete_message: @delete_message

  events:
    'click li.delete': 'destroy'

  destroy: -> @model.destroy wait: true
