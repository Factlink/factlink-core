class window.ClientRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'facts/new': 'newFact'
    'facts/:fact_id': 'show'

