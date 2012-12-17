class CreateSearchIndexForUser
  include Pavlov::Helpers

  @queue = :search_index_operations

  def self.perform(user_id)
    user = User.find(user_id)

    if user
      command :elastic_search_index_user_for_text_search, user
    else
      raise "Failed adding index for user with user_id: #{user_id}"
    end
  end

end
