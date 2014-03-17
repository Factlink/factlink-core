module Queries
  class DeadUsersByIds # Returns DeadUser
    include Pavlov::Query

    attribute :user_ids
    attribute :by, Symbol, default: :_id

    private

    def execute
      Backend::Users.by_ids(user_ids: user_ids, by: by)
    end
  end
end
