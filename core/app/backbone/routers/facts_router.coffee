class window.FactsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':slug/f/:fact_id': 'showFact'