require 'pavlov'

class CreateSearchIndexForUser
  @queue = :mmm_search_index_operations

  def self.perform(user_id)
    user = User.find(user_id)

    if user
      Backend::Users.index_user(username: user.username)
    else
      fail "Failed adding index for user with user_id: #{user_id}"
    end
  end
end
