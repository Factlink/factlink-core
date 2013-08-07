module Queries
  module Channels
    class GetBySlugTitle
      include Pavlov::Query

      arguments :slug_title

      def validate
        validate_string :slug_title, slug_title
      end

      def execute
        Channel.find(
            slug_title: slug_title,
            created_by_id: created_by_id)
          .first
      end

      def created_by_id
        pavlov_options[:current_user].graph_user_id
      end
    end
  end
end
