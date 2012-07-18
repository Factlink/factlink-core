#= require ./fact_view.js

class window.ExtendedFactView extends FactView
  tagName: "section"
  id: "main-wrapper"

  template: "facts/_extended_fact"

  initialize: (opts) ->
    super(opts)
    @factWheelView = new InteractiveWheelView({
      model: @wheel,
      fact: @model,
      el: @$('.wheel')
    })
    @initRenderActions()

  initRenderActions: () ->
    # the extended factpage is rendered in ruby, so the render of this view is never called,
    # therefore we have to force the rendering which we do need to do in the frontend in the initialize
    @renderAddToChannel()
    @factWheelView.render();
    @renderUserPassportViews();


  renderUserPassportViews: ()->
    interacting_users = this.model.get('interacting_users')

    for user_activity in interacting_users.activity
      view = new UserPassportView
        model: new User(user_activity.user);
        el: @$('li.user[data-activity-id=' + user_activity.id + ']');
        activity: user_activity
      view.render()

