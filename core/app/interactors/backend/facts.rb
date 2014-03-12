module Backend
  module Facts
    extend self

    def votes(fact_id:)
      votes_for(fact_id, 'believes') + votes_for(fact_id, 'disbelieves')
    end

    def create(displaystring:, title:, url:)
      fact_data = FactData.new
      fact_data.displaystring = displaystring
      fact_data.title = title
      fact_data.save!

      site = Site.find_or_create_by url: url

      fact = Fact.new site: site
      fact.data = fact_data
      fact.save!
      
      fact.data.fact_id = fact.id
      fact.data.save!

      dead(fact)
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

    def dead(fact)
      DeadFact.new id:fact.id,
                   site_url: fact.site.url,
                   displaystring: fact.data.displaystring,
                   created_at: fact.data.created_at,
                   site_title: fact.data.title
    end
  end
end
