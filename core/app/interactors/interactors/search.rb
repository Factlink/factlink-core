module Interactors
  class Search
    include Pavlov::Interactor
    include Util::CanCan
    include Util::Search

    arguments :keywords, :page, :row_count

    def validate
      raise 'Keywords should be an string.' unless @keywords.kind_of? String
      raise 'Keywords must not be empty.'   unless @keywords.length > 0
    end

    def use_query
      :elastic_search_all
    end

    def valid_result?(res)
      not invalid_result?(res)
    end

    def invalid_result?(res)
        res.nil? or
        (res.class == FactData and FactData.invalid(res)) or
        (res.class == User and res.hidden) or
        (res.class == Topic and res.top_channels(3).length <= 0)
    end

    def keyword_min_length
      1
    end

    def authorized?
      can? :index, Fact
    end
  end
end
