module Facts
  class FactWheel < Mustache::Railstache
    def authority
      self[:fact].get_opinion.as_percentages[:authority]
    end

    def opinion_types
      opinions_for_fact(self[:fact])
    end

    private
      def opinions_for_fact(fact)
        {
          believe: {
            percentage: fact.get_opinion.as_percentages[:believe][:percentage],
            is_user_opinion: user_signed_in? && current_graph_user.has_opinion?(:believes, fact),
          },
          doubt: {
            percentage: fact.get_opinion.as_percentages[:doubt][:percentage],
            is_user_opinion: user_signed_in? && current_graph_user.has_opinion?(:doubts, fact),
          },
          disbelieve: {
            percentage: fact.get_opinion.as_percentages[:disbelieve][:percentage],
            is_user_opinion: user_signed_in? && current_graph_user.has_opinion?(:disbelieves, fact)
          }
        }
      end
  end
end
