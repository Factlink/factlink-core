class window.UserBackButton extends BackButton

  update: ->
    username = @options.model.get('username')
    @set url: username, text: "#{ username.capitalize() }'s profile" if username
