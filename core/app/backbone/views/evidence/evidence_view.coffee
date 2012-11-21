class window.EvidenceBaseView extends Backbone.Marionette.Layout
  tagName:   'li'
  className: 'evidence-item'
  template:  'evidence/base'

  regions:
    voteRegion:       '.evidence-vote-region'
    userAvatarRegion: '.evidence-user-avatar-region'
    activityRegion:   '.evidence-activity-region'
    mainRegion:       '.evidence-main-region'
    popoverRegion:    '.evidence-popover-region'



class window.EvidenceUserAvatarView extends Backbone.Marionette.ItemView
  className: 'evidence-user-avatar'
  template:  'evidence/user_avatar'

  templateHelpers: => creator: @model.creator().toJSON()



class window.EvidenceActivityView extends Backbone.Marionette.ItemView
  className: 'evidence-activity'
  template:  'evidence/activity'

  templateHelpers: => creator: @model.creator().toJSON()
