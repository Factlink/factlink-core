window.ActivitiesGroupView =
  new: (options)->
    switch options.model.get("action")
      when "created_comment", "created_sub_comment"
        new CreatedCommentView options
      when "followed_user"
        new ReactView
          component: ReactFollowedUser(options)

class window.CreatedCommentView extends Backbone.Marionette.Layout
  className: 'feed-activity'
  template: "activities/created_comment"
  templateHelpers: ->
    user: @user()?.toJSON()

  regions:
    factRegion: '.js-region-fact'

  user: ->
    new User @model.get('user')

  onRender: ->
    @factRegion.show new ReactView
      component: ReactFact
        model: @fact()

  fact: ->
    new Fact @model.get("fact")

ReactFollowedUser = React.createBackboneClass
  displayName: 'ReactFollowedUser'

  render: ->
    user = new User @model().get('user')
    followed_user = new User @model().get('followed_user')

    _div [className: 'feed-activity'],
      _div [className: "feed-activity-user"],
        _a [href: user.link(), rel:"backbone"],
          _img [className:"image-48px feed-activity-user-avatar", src: user.avatar_url(48)]

      _div [className:"feed-activity-container"],
        _div [className:"feed-activity-heading"],
          _div [className:"feed-activity-action"],
            _a [className:"feed-activity-username", href: user.link(), rel:"backbone"],
                user.name
            _span [className:"feed-activity-description"],
              Factlink.Global.t.followed
            _a ["feed-activity-username", href: followed_user.link(), rel:"backbone"],
              _img ["feed-activity-user-avatar image-32px", src: followed_user.avatar_url(32)]
              followed_user.get('name')
          _div ["feed-activity-time"],
            TimeAgo(time: @model().get('created_at'))
