class window.UserInTopFactView extends Backbone.Marionette.ItemView
  template: 'facts/top_fact_user'
  tagName:  'span'

  templateHelpers: =>
    name: if @model.is_current_user()
            Factlink.Global.t.you
          else
            @model.get('name')
    show_links:
          Factlink.Global.signed_in and not @model.is_current_user()
