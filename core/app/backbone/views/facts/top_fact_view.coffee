class window.TopFactView extends Backbone.Marionette.Layout
  className: 'top-fact'

  template: 'facts/top_fact'

  events:
    'click .js-undo': -> @model.destroy()

  regions:
    deleteRegion: '.js-delete-region'
    factVoteTableRegion: '.js-fact-vote-table-region'

  templateHelpers: =>
    showDelete: @model.can_destroy()

  onRender: ->
    @deleteRegion.show @_deleteButtonView() if @model.can_destroy()
    if Factlink.Global.can_haz.opinions_of_users_and_comments
      @factVoteTableRegion.show new ReactView
        component: ReactVoteArea
          model: @model
      @model.getVotes().fetch()

  _deleteButtonView: ->
    new ReactView
      component: ReactDeleteButton
        model: @model,
        text: 'Undo' if @model.justCreated()
        onDelete: ->
          @model.destroy
            wait: true
            success: -> mp_track "Factlink: Destroy"
