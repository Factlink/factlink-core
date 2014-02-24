class window.FeedActivitiesView extends Backbone.Marionette.Layout
  template: 'feed/feed'

  regions:
    activityList: '.js-region-activity-list'

  events:
    "click .js-activities-refresh": "refresh"

  templateHelpers: ->
    title: Factlink.Global.t.stream.capitalize()

  onRender: ->
    @activityList.show new ActivitiesView
      collection: @collection
      disableEmptyView: @options.disableEmptyView
