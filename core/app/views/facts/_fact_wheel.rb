module Facts
  class FactWheel < Mustache::Railstache
    def mock
      {
        authority: "0.0",
        opinion_types: opinions_for_hash({
          believe: {
            percentage: 33,
            is_user_opinion: false
          },
          doubt: {
            percentage: 33,
            is_user_opinion: false
          },
          disbelieve: {
            percentage: 33,
            is_user_opinion: false
          }
        })
      }
    end

    def authority
      self[:fact].get_opinion.as_percentages[:authority]
    end

    def opinion_types
      opinions_for_fact(self[:fact])
    end

    private
      def opinions_for_fact(fact)
        opinions_for_hash({
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
        })
      end

      def opinions_for_hash(hash)
        [
          {
            :type => 'believe',
            :groupname => t(:fact_believe_opinion).titleize,
            :percentage => hash[:believe][:percentage],
            :is_user_opinion => hash[:believe][:is_user_opinion],
            :color => "#98d100",
          }, {
            :type => 'doubt',
            :groupname => t(:fact_doubt_opinion).titleize,
            :percentage => hash[:doubt][:percentage],
            :is_user_opinion => hash[:doubt][:is_user_opinion],
            :color => "#36a9e1",
          }, {
            :type => 'disbelieve',
            :groupname => t(:fact_disbelieve_opinion).titleize,
            :percentage => hash[:disbelieve][:percentage],
            :is_user_opinion => hash[:disbelieve][:is_user_opinion],
            :color => "#e94e1b",
          }
        ]
      end
  end
end
