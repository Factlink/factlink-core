class window.UserActivitiesView extends Backbone.Marionette.CompositeView

  template:  'activities/user-activities'
  className: 'activity-block'
  itemView: Backbone.View
  itemViewContainer: ".the-activities"

  @new: (options)->
    new (@classForModel(options.model))(options)

  @classForModel: (model) ->
    if model.get("action") == "added_fact_to_channel"
      UserFactActivitiesView
    else if model.get('subject_class') == "Channel"
      UserChannelActivitiesView
    else if model.get('action') in ["added_supporting_evidence", "added_weakening_evidence"]
      EvidenceActivitiesView
    else if model.get('action') in ["believes", "doubts", "disbelieves"]
      OpinionActivitiesView
    else
      UserActivitiesView


  appendable: (m) -> false

  buildItemView: (item, ItemView, options) ->
    #ignore ItemView
    newItemView = window.getActivityItemViewFor(item)
    super(item, newItemView, options)

class UserChannelActivitiesView extends UserActivitiesView
  appendable: (m) ->
    return false unless @model.get('username') == m.get('username')

    return m.get('subject_class') == "Channel"


class EvidenceActivitiesView extends UserActivitiesView
  appendable: (m) ->
    return false unless @model.get('username') == m.get('username')

    correct_action = m.get('action') in ["added_supporting_evidence", "added_weakening_evidence"]

    same_fact = @model.get('activity')?.fact?.id == m.get('activity')?.fact?.id

    correct_action and same_fact


class OpinionActivitiesView extends UserActivitiesView
  appendable: (m) ->
    return false unless @model.get('username') == m.get('username')

    return @model.get('activity')?.fact?.id == m.get('activity')?.fact?.id

  appendHtml: (collectionView, itemView, index)->
    # hackey hackey:
    is_first_view = itemView.model.get('render_fact')

    if is_first_view
      collectionView.$(@itemViewContainer).append(itemView.el)
    # else: we do not care for old opinions

class UserFactActivitiesChannelView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template:
    text: """
      <a href="{{ activity.channel_url }}">{{ activity.channel_title }}</a>
    """

  appendSeparator: (text)-> @$el.append text

class UserFactActivitiesChannelsView extends Backbone.Marionette.CollectionView
  itemView: UserFactActivitiesChannelView
  tagName: 'span'

  initialEvents: ->
    @bindTo @collection, "add remove reset", @render, @

  insertItemSeparator: (itemView, index) ->
    sep = Backbone.Factlink.listSeparator(@collection.length, @collection.length, index)
    itemView.appendSeparator(sep) if sep?

  appendHtml: (collectionView, itemView, index) =>
    @insertItemSeparator itemView, index
    super(collectionView, itemView, index)

class UserFactActivitiesView extends Backbone.Marionette.Layout
  className: 'activity-block'

  template:
    text: """
    <div class="the-user">
      <a href="{{ user_profile_url }}" rel="backbone">{{{ avatar }}}</a>
    </div>

    <div class="the-link">
      <a href="{{ user_profile_url }}" rel="backbone">{{ username }}</a>
    </div>

    <div class="the-activities">
      <div>
        <span class="activity-description">{{activity.posted}} to <span class="js-region-channels"></span>
        </span>

        <span class="meta">{{ time_ago }} ago</span>

        <div class="js-region-fact"></div>
      </div>
    </div>
    """

  regions:
    factRegion: '.js-region-fact'
    channelsRegion: '.js-region-channels'

  onRender: ->
    @channelsRegion.show @channelsActivitiesView()
    @factRegion.show @factView()

  channelsActivitiesView: -> new UserFactActivitiesChannelsView collection: @collection

  factView: -> new FactView model: @fact()
  fact: -> new Fact @model.get("activity")["fact"]

  appendable: (m) ->
    return false unless @model.get('username') == m.get('username')

    correct_action = m.get('action') in ["added_fact_to_channel"]

    same_fact = @model.get('activity')?.fact?.id == m.get('activity')?.fact?.id

    correct_action and same_fact


