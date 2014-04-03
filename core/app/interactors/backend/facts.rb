module Backend
  module Facts
    extend self

    def get(fact_id:)
      fact_data = FactData.where(fact_id: fact_id).first
      raise Mongoid::Errors::DocumentNotFound, "Fact #{fact_id}" unless fact_data

      dead(fact_data)
    end

    # TODO: only use fact_id!
    def get_by_fact_data_id(fact_data_id:)
      get(fact_id: FactData.find(fact_data_id).fact_id)
    end

    def votes(fact_id:)
      votes_for(fact_id, 'believes') + votes_for(fact_id, 'disbelieves')
    end

    def create(displaystring:, site_title:, url:)
      fact_data = FactData.new
      fact_data.displaystring = displaystring
      fact_data.title = site_title
      fact_data.site_url = UrlNormalizer.normalize(url)
      fact_data.save!

      dead(fact_data)
    end

    def remove_opinion(fact_id:, graph_user:)
      Believable.new(Fact[fact_id].key).remove_opinionateds graph_user
    end

    def set_opinion(fact_id:, graph_user:, opinion:)
      Believable.new(Fact[fact_id].key).add_opiniated opinion, graph_user
    end

    def recently_viewed(graph_user_id:)
      RecentlyViewedFacts.by_user_id(GraphUser[graph_user_id].user_id).top(5).map do |fact|
        get(fact_id: fact.id)
      end
    end

    def add_to_recently_viewed(fact_id:, graph_user_id:)
      RecentlyViewedFacts.by_user_id(GraphUser[graph_user_id].user_id).add_fact_id fact_id
    end

    def for_url(site_url:)
      fact_datas = FactData.where(site_url: UrlNormalizer.normalize(site_url))

      fact_datas.map do |fact_data|
        {id: fact_data.fact_id, displaystring: fact_data.displaystring}
      end
    end

    private

    def votes_for(fact_id, type)
      graph_user_ids = believable(fact_id).opiniated(type).ids
      dead_users = Backend::Users.by_ids(user_ids: graph_user_ids, by: :graph_user_id)

      dead_users.map do |user|
        { username: user.username, user: user, type: type }
      end
    end

    def believable(fact_id)
      Believable.new Nest.new("Fact:#{fact_id}")
    end

    def dead(fact_data)
      DeadFact.new id: fact_data.fact_id,
                   site_url: fact_data.site_url,
                   displaystring: fact_data.displaystring,
                   created_at: fact_data.created_at,
                   site_title: fact_data.title
    end
  end
end
