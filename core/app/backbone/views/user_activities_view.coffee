class window.UserActivitiesView extends Backbone.Marionette.CompositeView

  template:  'activities/user-activities'
  className: 'activity-block'
  itemView: Backbone.View
  itemViewContainer: ".the-activities"

  @new: (options)->
    new (@classForModel(options.model))(options)

  @classForModel: (model) ->
    if model.get('subject_class') == "Channel"
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
