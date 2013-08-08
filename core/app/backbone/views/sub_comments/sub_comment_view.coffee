class SubCommentPoparrowView extends Backbone.Factlink.PoparrowView
  template: 'sub_comments/poparrow'

  initialize: (options)->
    @delete_message = options.delete_message

  templateHelpers: =>
    delete_message: @delete_message

  events:
    'click li.delete': 'destroy'

  destroy: -> @model.destroy wait: true

class window.SubCommentView extends Backbone.Marionette.Layout
  className: 'evidence-sub-comment'

  template: 'sub_comments/sub_comment'

  regions:
    poparrowRegion: '.js-region-evidence-sub-comment-poparrow'

  templateHelpers: => creator: @model.creator().toJSON()

  initialize: ->
    @listenTo @model, 'change', @render

  onRender: ->
    @setPoparrow() if Factlink.Global.signed_in

  setPoparrow: ->
    if @model.can_destroy()
      poparrowView = new SubCommentPoparrowView
                          model: @model,
                          delete_message: 'Remove this comment'
      @poparrowRegion.show poparrowView

class window.NDPSubCommentView extends SubCommentView

  template:
    text: """
      <div class="js-region-evidence-sub-comment-poparrow"></div>
      <img class="evidence-sub-comments-avatar" src="{{ creator.avatar_url_32 }}" height="32" width="32">
      <div class="evidence-sub-comment-author">
        <strong>
          {{#global.signed_in}}
          <a href="/{{ creator.username }}" rel="backbone">
          {{/global.signed_in}}
            {{ creator.name }}
          {{#global.signed_in}}
          </a>
          {{/global.signed_in}}
        </strong>
        ( <img src="{{global.brain_image}}"> <span class="evidence-sub-comment-authority">{{ creator.authority }}</span> )

        <span class="pull-right evidence-sub-comment-time-ago">{{time_ago}} {{ global.t.ago }}</span>
      </div>
      <div class="evidence-sub-comment-content">{{content}}</div>
    """
