class window.ChannelsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':username_unused/feed':                                   'showStream'
    't/:slug_title':                                           'showTopicFacts'

    'f/:fact_id': 'showFact' # keep url in sync with DiscussionModalOnFrontend
