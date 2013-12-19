class window.ClientRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'client/facts/new': 'showNewFact'
    'client/facts/:fact_id': 'showFact'
