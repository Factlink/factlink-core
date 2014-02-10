class window.TopFactView extends Backbone.Marionette.Layout
  className: 'top-fact'

  template: 'facts/top_fact'

  regions:
    factVoteTableRegion: '.js-fact-vote-table-region'

  onRender: ->
    if Factlink.Global.can_haz.opinions_of_users_and_comments
      @factVoteTableRegion.show new ReactView
        component: ReactVoteArea
          model: @model
      @model.getVotes().fetch()
