class window.InteractorNameView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'separator-list-item'
  template: 'fact_relations/interactor_name'

  templateHelpers: =>
    if Factlink.Global.signed_in
      show_links: => not @model.is_current_user()
      name: => if @model.is_current_user()
                'You'
               else
                @model.get('name')
    else
      show_links: false
