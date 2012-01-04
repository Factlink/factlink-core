module Facts
  class FactWheel < Mustache::Railstache
    def authority
      self[:fact].get_opinion.as_percentages[:authority]
    end

    def opinions
      opinions_for_user_and_fact(self[:fact])
    end

    def user_signed_in?
      self.view.user_signed_in?
    end

    private
      def opinions_for_user_and_fact(fact)
        [
          {
            :type => 'believe',
            :groupname => t(:fact_believe_opinion).titleize,
            :percentage => fact.get_opinion.as_percentages[:believe][:percentage],
            :is_current_opinion => user_signed_in? && current_graph_user.has_opinion?(:believes, fact),
            :color => "#98d100",
            :user_signed_in? => user_signed_in?,
          },
          {
            :type => 'doubt',
            :groupname => t(:fact_doubt_opinion).titleize,
            :percentage => fact.get_opinion.as_percentages[:doubt][:percentage],
            :is_current_opinion => user_signed_in? && current_graph_user.has_opinion?(:doubts, fact),
            :color => "#36a9e1",
            :user_signed_in? => user_signed_in?,
          },
          {
            :type => 'disbelieve',
            :groupname => t(:fact_disbelieve_opinion).titleize,
            :percentage => fact.get_opinion.as_percentages[:disbelieve][:percentage],
            :is_current_opinion => user_signed_in? && current_graph_user.has_opinion?(:disbelieves, fact),
            :color => "#e94e1b",
            :user_signed_in? => user_signed_in?,
          }
        ]
      end
  end
end