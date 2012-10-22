json.id             @user.id
json.name           @user.name
json.username       @user.username
json.location       @user.location
json.biography      @user.biography
json.gravatar_hash  Gravatar.hash(@user.email)
