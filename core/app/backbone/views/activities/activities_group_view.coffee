class window.ActivitiesGroupView extends Backbone.Marionette.CompositeView
  className: 'activity-group'
  itemView: Backbone.View
  itemViewContainer: ".js-region-activities"

  @new: (options)->
    new (@classForModel(options.model))(options)

  @classForModel: (model) ->
    switch model.get("action")
      when "created_comment", "created_sub_comment"
        UserFactActivitiesGroupView
      when "followed_user"
        UsersFollowedGroupView

  templateHelpers: ->
    user: @user?.toJSON()

  constructor: (options) ->
    options.collection = new Backbone.Collection [options.model]
    super(options)
    @user = new User @collection.first().get('user')

  tryAppend: (model) -> return false

class window.CreatedCommentView extends Backbone.Marionette.ItemView
  template: "activities/created_comment"

class window.FollowedUserView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'separator-list-item'
  template: "activities/followed_user"
  templateHelpers: =>
    followed_user: @user().toJSON()

  user: -> @_user ?= new User(@model.get('activity').followed_user)

class UserFactActivitiesGroupView extends ActivitiesGroupView
  template: 'activities/user_fact_activities_group'
  itemView: CreatedCommentView

  onRender: ->
    @$('.js-region-fact').html @factView().render().el

  onClose: ->
    @factView().close()

  factView: ->
    @_factView ?= new ReactView
      component: ReactFact
        model: @fact()

  fact: -> new Fact @model.get("activity").fact

class UsersFollowedGroupView extends ActivitiesGroupView
  template: 'activities/users_followed_group'
  itemView: FollowedUserView

