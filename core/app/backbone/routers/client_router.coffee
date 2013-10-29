class window.ClientRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'facts/new': 'showNewFact'
    'client/facts/:fact_id': 'showFact'
