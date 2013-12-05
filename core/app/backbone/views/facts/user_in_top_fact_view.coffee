class window.UserInTopFactView extends Backbone.Marionette.ItemView
  template: 'facts/top_fact_user'
  tagName:  'span'
  className: 'top-fact-user'

  templateHelpers: =>
    name: if @model.is_current_user()
            Factlink.Global.t.you
          else
            @model.get('name')
    show_links:
          !@model.is_current_user()

  onRender: ->
    UserPopoverContentView.makeTooltip @, @model,
      $offsetParent: @options.$offsetParent
