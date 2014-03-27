module Backend
  module Search
    extend self

    def search_all(keywords:, page:, row_count:, types:)
      records = ::ElasticSearch::Search.search keywords: keywords, page: page,
                                               row_count: row_count, types: types

      records.map do |record|
        get_object(record['_id'], record['_type'])
      end.compact
    end

    private

    def get_object id, type
      case type
      when'factdata'
        fact_data = FactData.find(id)
        return nil if fact_data.nil? || FactData.invalid(fact_data)

        Backend::Facts.get(fact_id: fact_data.fact_id)
      when 'user'
        user = Backend::Users.by_ids(user_ids: [id]).first

        return nil if user.deleted

        user
      else
        fail 'Object type unknown.'
      end
    end
  end
end
