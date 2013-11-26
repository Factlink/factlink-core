require 'pavlov'

class CreateSearchIndexForUser
  @queue = :mmm_search_index_operations

  def self.perform(user_id)
    user = User.find(user_id)

    if user
      Pavlov.command(:'text_search/index_user', user: user)
    else
      raise "Failed adding index for user with user_id: #{user_id}"
    end
  end
end
