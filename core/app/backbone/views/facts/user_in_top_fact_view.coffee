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
          Factlink.Global.signed_in and not @model.is_current_user()

  onRender: ->
    Backbone.Factlink.makeTooltipForView @,
      positioning: {align: 'left', side: 'bottom'}
      selector: '.js-user-link'
      $offsetParent: @options.$offsetParent
      tooltipViewFactory: => new UserPopoverContentView model: @model
