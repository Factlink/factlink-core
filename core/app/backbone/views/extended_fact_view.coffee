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
    interacting_users = this.model.get('interacting_users');

    _.each interacting_users.activity, (user)=>
      el = this.$('li.user[data-activity-id=' + user.id + ']');
      model = new User(user.user);

      view = new UserPassportView(
        model: model
        el: el
        activity: user)
      view.render();

