module Backend
  module Search
    extend self

    def search_all(keywords:, page:, row_count:, types:)
      PgSearch.multisearch(keywords).limit(row_count).map do |record|
        get_object(record.searchable_id, record.searchable_type)
      end
    end

    private

    def get_object id, type
      case type
      when'FactData'
        fact_data = FactData.find(id)
        return nil if fact_data.nil?

        fact = Backend::Facts.get(fact_id: fact_data.fact_id)

        {the_class: 'Annotation', the_object: fact}
      when 'User'
        user = Backend::Users.by_ids(user_ids: [id]).first

        return nil if user.deleted

        {the_class: 'User', the_object: user}
      else
        fail "Object type #{type} unknown."
      end
    end
  end
end
