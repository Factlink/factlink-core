class window.ActivitiesGroupView extends Backbone.Marionette.CompositeView
  itemView: Backbone.View
  itemViewContainer: ".js-region-activities"

  @new: (options)->
    switch options.model.get("action")
      when "created_comment", "created_sub_comment"
        new CreatedCommentView options
      when "followed_user"
        new FollowedUserView options

  templateHelpers: ->
    user: @user?.toJSON()

  constructor: (options) ->
    options.collection = new Backbone.Collection [options.model]
    super(options)
    @user = new User @collection.first().get('user')

  tryAppend: (model) -> return false

class window.CreatedCommentView extends Backbone.Marionette.Layout
  className: 'activity-group'
  template: "activities/created_comment"
  templateHelpers: ->
    user: @user()?.toJSON()

  regions:
    factRegion: '.js-region-fact'

  user: ->
    new User @model.get('user')

  onRender: ->
    console.info @fact()
    @factRegion.show new ReactView
      component: ReactFact
        model: @fact()

  fact: ->
    new Fact @model.get("activity").fact


class window.FollowedUserView extends Backbone.Marionette.ItemView
  className: 'activity-group'
  template: "activities/followed_user"
  templateHelpers: =>
    followed_user: @followed_user().toJSON()
    user: @user()?.toJSON()

  user: ->
    new User @model.get('user')

  followed_user: ->
    new User @model.get('activity').followed_user

