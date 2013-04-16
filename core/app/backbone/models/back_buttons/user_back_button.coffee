class window.UserBackButton extends BackButton

  update: ->
    username = @model.get('username')
    @set url: username, text: "#{ username.capitalize() }'s profile"
