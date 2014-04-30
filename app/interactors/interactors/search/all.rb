module Interactors
  module Search
    class All
      include Pavlov::Interactor
      include Util::CanCan

      arguments :keywords

      def execute
        row_count = 20 # WARNING: coupling with ReactSearchResults

        Backend::Search.search_all keywords: keywords, page: 1,
                                   row_count: row_count, types: [:factdata, :user]
      end

      def validate
        validate_nonempty_string :keywords, keywords
      end

      def authorized?
        true
      end
    end
  end
end
