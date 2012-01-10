module Facts
  class FactRelationSearchResult < Mustache::Railstache
    def displaystring
      self[:fact].displaystring
    end

    def id
      self[:fact].fact.id
    end

  end
end
