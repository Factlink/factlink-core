class window.FactsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':username_unused/feed': 'showStream'
    'f/:fact_id': 'showFact' # keep url in sync with DiscussionModalOnFrontend
