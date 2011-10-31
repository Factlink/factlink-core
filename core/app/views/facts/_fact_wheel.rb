module Facts
  class FactWheel < Mustache::Rails
    
    def user_signed_in?(user=self[:current_user])
      user
    end
    
    def authority
      self[:fact].get_opinion.as_percentages[:authority]
    end


    def opinions
      opinions_for_user_and_fact(self[:fact],self[:current_user])
    end
    
    def opinions_for_user_and_fact(fact,user)
      [
        {
          :type => 'believe',
          :groupname => 'Top agree',
          :percentage => fact.get_opinion.as_percentages[:believe][:percentage],
          :is_current_opinion => user_signed_in?(current_user) && user.graph_user.has_opinion?(:believes, fact),
          :color => "#98d100",
          :graph_users => graph_users_with_link(fact.opiniated(:believes).to_a.take(6)),
        },
        {
          :type => 'doubt',
          :groupname => 'Top not sure',
          :percentage => fact.get_opinion.as_percentages[:doubt][:percentage],
          :is_current_opinion => user_signed_in?(current_user) && user.graph_user.has_opinion?(:doubts, fact),
          :color => "#36a9e1",
          :graph_users => graph_users_with_link(fact.opiniated(:doubts).to_a.take(6)),
        },
        {
          :type => 'disbelieve',
          :groupname => 'Top disagree',
          :percentage => fact.get_opinion.as_percentages[:disbelieve][:percentage],
          :is_current_opinion => user_signed_in?(current_user) && user.graph_user.has_opinion?(:disbelieves, fact),
          :color => "#e94e1b",
          :graph_users => graph_users_with_link(fact.opiniated(:disbelieves).to_a.take(6)),
        }
      ]
    end


    def graph_users_with_link(graph_users)
      graph_users.map do |gu|
        {
          :username => gu.user.username,
          :link => link_for(gu),
        }
      end
    end
  
    def link_for(gu)
      link_to(
        image_tag(gu.user.avatar, :size => "24x24", :title => "#{gu.user.username} (#{gu.rounded_authority})"),
        user_profile_path(gu.user.username), :target => "_top" )
    end

  end
end
