require_relative '../../pavlov'

module Queries
  module Comments
    class GraphUserOpinion
      include Pavlov::Query
      arguments :comment_id, :graph_user

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
      end

      def execute
        possible_opinions.each do |opinion|
          return opinion if has_opinion?(opinion)
        end
        nil
      end

      def possible_opinions
        Opinion.types
      end

      def has_opinion? type
        people_who_believe(type).include? @graph_user
      end

      def people_who_believe type
        believable.opiniated(type)
      end

      def believable
        @believable ||= Believable::Commentje.new @comment_id
      end
    end
  end
end
