module Queries
  module Comments
    class AddAuthorityAndOpinion
      include Pavlov::Query
      arguments :comment, :fact
      def execute
        @comment.authority = query :authority_on_fact_for, @fact, @comment.created_by.graph_user
        opinion_object = query :opinion_for_comment, @comment.id.to_s, @fact

        KillObject.comment @comment,
          opinion_object: opinion_object,
          current_user_opinion: current_user_opinion
      end

      # TODO-0312 fix this shit

      # HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK
      # HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK
      # HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK
      # HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK# HACK

      # extract to query, and then it should be ok-ish
      def current_user_opinion
        Opinion.types.each do |opinion|
          return opinion if has_opinion?(opinion)
        end
        return nil
      end

      def believable
        @believable ||= Believable::Commentje.new(@comment.id.to_s)
      end

      def has_opinion?(type)
        believable.opiniated(type).include? current_graph_user
      end

      def current_graph_user
        @options[:current_user].graph_user
      end
    end
  end
end
