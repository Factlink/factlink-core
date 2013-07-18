class window.InteractorNameView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'separator-list-item'
  template: 'fact_relations/interactor_name'

  templateHelpers: =>
    name: if @model.is_current_user()
            Factlink.Global.t.you.capitalize()
          else
            @model.get('name')
    show_links:
      Factlink.Global.signed_in and not @model.is_current_user()
