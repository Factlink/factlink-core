class window.UserWithAuthorityBox extends Backbone.Marionette.ItemView
  template: "users/user_with_authority_box"
  className: "created_by_info"

  initialize: ->
    console.info( this.model );

  templateHelpers: ->
    authority: @options.authority
