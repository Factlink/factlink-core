class window.UserActivitiesGroupView extends Backbone.Marionette.CompositeView
  template: 'activities/user_activities_group'
  className: 'activity-group'
  itemView: Backbone.View
  itemViewContainer: ".js-region-activities"

  @actions: ["created_channel", "added_subchannel"]
  actions: -> UserActivitiesGroupView.actions

  @new: (options)->
    new (@classForModel(options.model))(options)

  @classForModel: (model) ->
    action = model.get("action")

    if action in UserFactActivitiesGroupView.actions
      UserFactActivitiesGroupView
    else
      UserActivitiesGroupView

  initialize: -> @collection = new Backbone.Collection [@model]

  sameUser: (model) -> @model.get('username') == model.get('username')

  appendable: (model) -> @sameUser(model) and model.get('action') in @actions()

  append: (model) ->
    return false unless @appendable(model)

    unless @lastView?.append(model)
      @collection.add model
    true

  buildItemView: (item, ItemView, options) ->
    #ignore ItemView
    NewItemView = ActivityItemView.classForModel(item)
    @lastView = super(item, NewItemView, options)

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
