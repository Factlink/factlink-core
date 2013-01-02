class window.UserActivitiesGroupView extends Backbone.Marionette.CompositeView
  @actions: []
  actions: -> UserActivitiesGroupView.actions

  template:
    text:
      """
      <div class="activity-group-user">
        <a href="{{ user_profile_url }}" rel="backbone">{{{ avatar }}}</a>
      </div>

      <div class="activity-group-link">
        <a href="{{ user_profile_url }}" rel="backbone">{{ username }}</a>
      </div>

      <div class="activity-group-activities js-region-activities"></div>
      """

  className: 'activity-group'
  itemView: Backbone.View
  itemViewContainer: ".js-region-activities"

  @new: (options)->
    new (@classForModel(options.model))(options)

  @classForModel: (model) ->
    action = model.get("action")

    if action in UserFactActivitiesGroupView.actions
      UserFactActivitiesGroupView
    else if action in UserChannelActivitiesGroupView.actions
      UserChannelActivitiesGroupView
    else if action in UserEvidenceActivitiesGroupView.actions
      UserEvidenceActivitiesGroupView
    else if action in UserOpinionActivitiesGroupView.actions
      UserOpinionActivitiesGroupView
    else
      UserActivitiesGroupView

  initialize: -> @collection = new Backbone.Collection [@model]

  sameUser: (model) -> @model.get('username') == model.get('username')

  appendable: (model) -> @sameUser(model) and model.get('action') in @actions()

  append: (model) ->
    return false unless @appendable(model)
    @collection.add model unless @lastView?.append(model)
    true

  buildItemView: (item, ItemView, options) ->
    #ignore ItemView
    NewItemView = window.getActivityItemViewFor(item)
    @lastView = super(item, NewItemView, options)

class UserFactActivitiesGroupView extends UserActivitiesGroupView
  @actions: ["added_fact_to_channel"]#, "created_comment", "created_sub_comment"]
  actions: -> UserFactActivitiesGroupView.actions

  template:
    text: """
      <div class="activity-group-user">
        <a href="{{ user_profile_url }}" rel="backbone">{{{ avatar }}}</a>
      </div>

      <div class="activity-group-link">
        <a href="{{ user_profile_url }}" rel="backbone">{{ username }}</a>
      </div>

      <div class="activity-group-activities js-region-activities"></div>
      
      <div class="activity-group-fact js-region-fact"></div>
    """

  onRender: ->
    @$('.js-region-fact').html @factView().render().el

  onClose: ->
    @factView().close()

  factView: -> @_factView ?= new FactView model: @fact()
  fact: -> new Fact @model.get("activity").fact

  sameFact: (model) ->
    @model.get('activity').fact?.id == model.get('activity').fact?.id

  appendable: (model) -> super(model) and @sameFact(model)

class UserChannelActivitiesGroupView extends UserActivitiesGroupView
  @actions: ["created_channel", "added_subchannel"]
  actions: -> UserChannelActivitiesGroupView.actions

class UserEvidenceActivitiesGroupView extends UserFactActivitiesGroupView
  @actions: ["added_supporting_evidence", "added_weakening_evidence"]
  actions: -> UserEvidenceActivitiesGroupView.actions

class UserOpinionActivitiesGroupView extends UserFactActivitiesGroupView
  @actions: ["believes", "doubts", "disbelieves"]
  actions: -> UserOpinionActivitiesGroupView.actions

  appendHtml: (collectionView, itemView, index)->
    if !@has_view
      collectionView.$(@itemViewContainer).append(itemView.el)
      @has_view = true
    # else: we do not care for old opinions
