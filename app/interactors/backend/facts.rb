module Backend
  module Facts
    extend self

    def get(fact_id:)
      fact_data = FactData.where(fact_id: fact_id).first
      raise ActiveRecord::RecordNotFound, ["FactData", {fact_id: fact_id}] unless fact_data

      dead(fact_data)
    end

    # TODO: only use fact_id!
    def get_by_fact_data_id(fact_data_id:)
      get(fact_id: FactData.find(fact_data_id).fact_id)
    end

    def votes(fact_id:)
      fact_data_id = FactData.where(fact_id: fact_id).first.id
      user_ids = FactDataInteresting.where(fact_data_id: fact_data_id).map(&:user_id)
      dead_users = Backend::Users.by_ids(user_ids: user_ids)

      dead_users.map do |user|
        { username: user.username, user: user }
      end
    end

    def create(displaystring:, site_title:, site_url:, created_at:, created_by_id:, fact_id: nil, group_id: nil)
      fact_data = FactData.new
      fact_data.created_by_id = created_by_id
      fact_data.displaystring = displaystring
      fact_data.title = site_title
      fact_data.site_url = UrlNormalizer.normalize(site_url)
      fact_data.fact_id = fact_id
      fact_data.group_id = group_id
      fact_data.created_at = created_at
      fact_data.updated_at = created_at
      fact_data.save!

      dead(fact_data)
    end

    def remove_interesting(fact_id:, user_id:)
      fact_data_id = FactData.where(fact_id: fact_id).first.id

      FactDataInteresting.where(fact_data_id: fact_data_id, user_id: user_id)
                         .each {|interesting| interesting.destroy}
    end

    def set_interesting(fact_id:, user_id:)
      remove_interesting fact_id: fact_id, user_id: user_id

      fact_data_id = FactData.where(fact_id: fact_id).first.id
      FactDataInteresting.create! fact_data_id: fact_data_id, user_id: user_id
    end

    def for_url(site_url:)
      fact_datas = FactData.where(site_url: UrlNormalizer.normalize(site_url))

      fact_datas.map do |fact_data|
        {id: fact_data.fact_id, displaystring: fact_data.displaystring}
      end
    end

    private

    def dead(fact_data)
      DeadFact.new id: fact_data.fact_id.to_s,
                   site_url: fact_data.site_url,
                   displaystring: fact_data.displaystring,
                   created_at: fact_data.created_at,
                   site_title: fact_data.title
    end
  end
end
