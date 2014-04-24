module Backend
  module Followers
    extend self

    def followers_for_fact_id fact_id
      fact_data_id = FactData.where(fact_id: fact_id).first.id
      FactDataInteresting.where(fact_data_id: fact_data_id).map(&:user_id)
    end
  end
end
