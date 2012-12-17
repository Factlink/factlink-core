class CreateSearchIndexForUser

  @queue = :search_index_operations

  def self.perform(user_id)
    user = User.find(user_id)

    if user
      Commands::ElasticSearchIndexUserForTextSearch.new(user).call
    else
      raise "Failed adding index for user with user_id: #{user_id}"
    end
  end

end
