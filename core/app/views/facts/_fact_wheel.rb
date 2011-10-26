module Facts
  class FactWheel < Mustache::Rails
    def user_signed_in?
      @current_user
    end
    
    def authority
      self[:fact].get_opinion.as_percentages[:authority]
    end

    def opinions
      [
        {
          :type => 'believe',
          :groupname => 'believers',
          :percentage => self[:fact].get_opinion.as_percentages[:believe][:percentage],
          :is_current_opinion => user_signed_in? && self[:current_user].graph_user.has_opinion?(:believes, self[:fact]),
          :color => "#95c11f",
          :graph_users => graph_users_with_link(self[:fact].opiniated(:believes).to_a.take(6)),
        },
        {
          :type => 'doubt',
          :groupname => 'doubters',
          :percentage => self[:fact].get_opinion.as_percentages[:doubt][:percentage],
          :is_current_opinion => user_signed_in? && self[:current_user].graph_user.has_opinion?(:doubts, self[:fact]),
          :color => "#36a9e1",
          :graph_users => graph_users_with_link(self[:fact].opiniated(:doubts).to_a.take(6)),
        },
        {
          :type => 'disbelieve',
          :groupname => 'disbelievers',
          :percentage => self[:fact].get_opinion.as_percentages[:disbelieve][:percentage],
          :is_current_opinion => user_signed_in? && self[:current_user].graph_user.has_opinion?(:disbelieves, self[:fact]),
          :color => "#e94e1b",
          :graph_users => graph_users_with_link(self[:fact].opiniated(:disbelieves).to_a.take(6)),
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