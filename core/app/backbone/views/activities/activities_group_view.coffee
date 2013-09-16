class window.ActivitiesGroupView extends Backbone.Marionette.CompositeView
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

    return UserActivitiesGroupView

  templateHelpers: ->
    user: @user?.toJSON()

  constructor: (options) ->
    options.collection = new Backbone.Collection [options.model]
    super(options)
    @user = new User @collection.first().get('user')

  actions: -> []

  appendable: (model) -> model.get('action') in @actions()

  tryAppend: (model) ->
    return false unless @appendable(model)
    @append model
    true

  append: (model) ->
    unless @lastView?.tryAppend(model)
      @collection.add model

class UserActivitiesGroupView extends ActivitiesGroupView
  template: 'activities/user_activities_group'
  className: 'activity-group'
  itemView: Backbone.View
  itemViewContainer: ".js-region-activities"

  @actions: ["created_channel", "added_subchannel"]
  actions: -> UserActivitiesGroupView.actions

  constructor: ->
    super
    @on 'render', @makeUserTooltip

  itemViewOptions: ->
    $offsetParent: @$el

  sameUser: (model) -> @model.user().get('username') == model.user().get('username')

  appendable: (model) -> super(model) and @sameUser(model)

  buildItemView: (item, ItemView, options) ->
    NewItemView = ActivityItemView.classForModel(item)
    @lastView = super(item, NewItemView, options)

  makeUserTooltip: ->
    user = @model.user()
    Backbone.Factlink.makeTooltipForView @,
      positioning: {align: 'left', side: 'bottom'}
      selector: '.js-activity-group-user'
      tooltipViewFactory: => new UserPopoverContentView model: @model.user()

class UserFactActivitiesGroupView extends UserActivitiesGroupView
  template: 'activities/user_fact_activities_group'

  @actions: ["added_first_factlink", "added_fact_to_channel", "created_comment", "created_sub_comment", "added_supporting_evidence", "added_weakening_evidence", "believes", "doubts", "disbelieves"]
  actions: -> UserFactActivitiesGroupView.actions

  onRender: ->
    @$('.js-region-fact').html @factView().render().el

  onClose: ->
    @factView().close()

  factView: -> @_factView ?= new FactView model: @fact()
  fact: -> new Fact @model.get("activity").fact

  sameFact: (model) ->
    @model.get('activity').fact?.id == model.get('activity').fact?.id

  appendable: (model) -> super(model) and @sameFact(model)

class UsersFollowedGroupView extends UserActivitiesGroupView
  template: 'activities/users_followed_group'

  @actions: ["followed_user"]
  actions: -> UsersFollowedGroupView.actions

