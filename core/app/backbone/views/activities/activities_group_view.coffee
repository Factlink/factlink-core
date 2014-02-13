class window.ActivitiesGroupView extends Backbone.Marionette.CompositeView
  className: 'activity-group'
  itemView: Backbone.View
  itemViewContainer: ".js-region-activities"

  @new: (options)->
    new (@classForModel(options.model))(options)

  @classForModel: (model) ->
    action = model.get("action")

    specialized_group_views = [
      UserFactActivitiesGroupView,
      UsersFollowedGroupView
    ]

    for group_view in specialized_group_views
      if action in group_view.actions
        return group_view

    return ActivitiesGroupView

  templateHelpers: ->
    user: @user?.toJSON()

  constructor: (options) ->
    options.collection = new Backbone.Collection [options.model]
    super(options)
    @user = new User @collection.first().get('user')

  actions: -> []

  tryAppend: (model) -> return false

  buildItemView: (item, ItemView, itemViewOptions) ->
    options = _.extend({model: item}, itemViewOptions)
    @lastView = ActivityItemView.for(options)

class UserFactActivitiesGroupView extends ActivitiesGroupView
  template: 'activities/user_fact_activities_group'

  @actions: ["created_comment", "created_sub_comment"]

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

  @actions: ["followed_user"]

