module Backend
  module Facts
    extend self

    def votes(fact_id:)
      votes_for(fact_id, 'believes') + votes_for(fact_id, 'disbelieves')
    end

    private

    def votes_for(fact_id, type)
      graph_user_ids = believable(fact_id).opiniated(type).ids
      dead_users = Pavlov.query :dead_users_by_ids, user_ids: graph_user_ids, by: :graph_user_id

      dead_users.map do |user|
        { username: user.username, user: user, type: type }
      end
    end

    def believable(fact_id)
      Believable.new Nest.new("Fact:#{fact_id}")
    end
  end
end
