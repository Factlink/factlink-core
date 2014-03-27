require 'pavlov'

class CreateSearchIndexForUser
  @queue = :mmm_search_index_operations

  def self.perform(user_id)
    user = User.find(user_id)

    if user
      user.update_search_index
    else
      fail "Failed adding index for user with user_id: #{user_id}"
    end
  end
end
