#= require ./fact_view.js

class window.ExtendedFactView extends FactView
  tagName: "section"
  id: "main-wrapper"

  template: "facts/_extended_fact"

  showLines: 6;

  onRender: ->
    super()
    @renderUserPassportViews();

  renderUserPassportViews: ()->
    interacting_users = this.model.get('interacting_users')

    for user_activity in interacting_users.activity
      view = new UserPassportView
        model: new User(user_activity.user);
        el: @$('li.user[data-activity-id=' + user_activity.id + ']');
        activity: user_activity
      view.render()

