class window.ClientRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'facts/new': 'showNewFact'
    'facts/:fact_id': 'showFact'

