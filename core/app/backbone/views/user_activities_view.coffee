class window.UserActivitiesView extends Backbone.Marionette.CompositeView

  template:  'activities/user-activities'
  className: 'activity-block'
  itemView: Backbone.View
  itemViewContainer: ".the-activities"

  appendable: (new_model) ->
    same_user = this.model.get('username') == new_model.get('username')
    same_user and (@appendableForChannel(new_model) or @appendableForEvidence(new_model))

  buildItemView: (item, ItemView) ->
    #ignore ItemView
    newItemView = window.getActivityItemViewFor(item)
    Backbone.Marionette.CompositeView.prototype.buildItemView.call(this,item, newItemView)

  appendableForChannel: (new_model) ->
    new_subject_is_channel     =  new_model.get('subject_class') == "Channel"
    current_subject_is_channel = this.model.get('subject_class') == "Channel"

    new_subject_is_channel and current_subject_is_channel

  appendableForEvidence: (new_model) ->
    new_subject_is_evidence =      (new_model.get('action') == "added_supporting_evidence") or (new_model.get('action') == "added_weakening_evidence")
    current_subject_is_evidence = (this.model.get('action') == "added_supporting_evidence") or (this.model.get('action') == "added_weakening_evidence")

    new_subject_is_evidence and current_subject_is_evidence