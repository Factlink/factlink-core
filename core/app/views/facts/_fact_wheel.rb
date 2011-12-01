module Facts
  class FactWheel < Mustache::Railstache
    def self.for_fact_and_view(fact, view, channel=nil, modal=nil)
      fw = new(false)
      fw.view = view
      fw[:channel] = channel
      fw[:fact] = fact
      fw[:modal] = modal
      return fw
    end
    
    def authority
      self[:fact].get_opinion.as_percentages[:authority]
    end
    
    def opinions
      opinions_for_user_and_fact(self[:fact])
    end
    
    def user_signed_in?
      self.view.user_signed_in?
    end
    
    def to_hash
      {
        :authority => authority,
        :opinions => opinions,
        :user_signed_in? => user_signed_in?,
      }
    end
    
    private
      def opinions_for_user_and_fact(fact)
        [
          {
            :type => 'believe',
            :groupname => 'Agree',
            :percentage => fact.get_opinion.as_percentages[:believe][:percentage],
            :is_current_opinion => user_signed_in? && current_graph_user.has_opinion?(:believes, fact),
            :color => "#98d100",
          },
          {
            :type => 'doubt',
            :groupname => 'Neutral',
            :percentage => fact.get_opinion.as_percentages[:doubt][:percentage],
            :is_current_opinion => user_signed_in? && current_graph_user.has_opinion?(:doubts, fact),
            :color => "#36a9e1",
          },
          {
            :type => 'disbelieve',
            :groupname => 'Disagree',
            :percentage => fact.get_opinion.as_percentages[:disbelieve][:percentage],
            :is_current_opinion => user_signed_in? && current_graph_user.has_opinion?(:disbelieves, fact),
            :color => "#e94e1b",
          }
        ]
      end
  end
end