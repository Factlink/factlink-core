window.ActivitiesGroupView =
  new: (options)->
    switch options.model.get("action")
      when "created_comment", "created_sub_comment"
        new CreatedCommentView options
      when "followed_user"
        new FollowedUserView options

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


class window.FollowedUserView extends Backbone.Marionette.ItemView
  className: 'feed-activity'
  template: "activities/followed_user"
  templateHelpers: =>
    followed_user: @followed_user().toJSON()
    user: @user()?.toJSON()

  user: ->
    new User @model.get('user')

  followed_user: ->
    new User @model.get('followed_user')

