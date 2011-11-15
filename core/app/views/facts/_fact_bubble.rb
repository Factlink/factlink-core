module Facts
  class FactBubble < Mustache::Railstache
    def current_graph_user
      @current_graph_user ||= self[:current_user].graph_user
    end
    
    def channels
      current_graph_user.editable_channels_for(self[:fact])
    end
  
    def channel_path
      channels_path(@current_user.username)
    end
    def id
      self[:fact].id
    end
    def user_signed_in?(user=self[:current_user])
      user
    end
  
    def authority
      self[:fact].get_opinion.as_percentages[:authority]
    end


    def opinions
      opinions_for_user_and_fact(self[:fact])
    end
  
    def opinions_for_user_and_fact(fact)
      [
        {
          :type => 'believe',
          :groupname => 'Agree',
          :percentage => fact.get_opinion.as_percentages[:believe][:percentage],
          :is_current_opinion => user_signed_in?(current_user) && current_graph_user.has_opinion?(:believes, fact),
          :color => "#98d100",
          :graph_users => graph_users_with_link(fact.opiniated(:believes).to_a.take(6)),
        },
        {
          :type => 'doubt',
          :groupname => 'Neutral',
          :percentage => fact.get_opinion.as_percentages[:doubt][:percentage],
          :is_current_opinion => user_signed_in?(current_user) && current_graph_user.has_opinion?(:doubts, fact),
          :color => "#36a9e1",
          :graph_users => graph_users_with_link(fact.opiniated(:doubts).to_a.take(6)),
        },
        {
          :type => 'disbelieve',
          :groupname => 'Disagree',
          :percentage => fact.get_opinion.as_percentages[:disbelieve][:percentage],
          :is_current_opinion => user_signed_in?(current_user) && current_graph_user.has_opinion?(:disbelieves, fact),
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
      imgtag = image_tag(gu.user.avatar.url(:small), :size => "24x24", :title => "#{gu.user.username} (#{gu.rounded_authority})")
      path = view.user_profile_path(gu.user.username)
      link_to( imgtag, path, :target => "_top" )
    end

    def i_am_fact_owner
      (self[:fact].created_by == current_graph_user)
    end

    def editable_title_class
      if user_signed_in? and i_am_fact_owner
        return " edit "
      else
        return ""
      end 
    end

    def pretty_url
      self[:fact].site.url.gsub(/http(s?):\/\//,'').split('/')[0]
    end

    def delete_link
      link_to(image_tag('/images/trash.gif') + "Delete", fact_path(self[:fact].id), :confirm => "You will delete this Factlink. Are you sure?", :method => :delete, :remote => true )
    end

    def proxy_scroll_url
      return FactlinkUI::Application.config.proxy_url + "?url=" + URI.escape(self[:fact].site.url) + "&scrollto=" + URI.escape(self[:fact].id)
    end

    def show_links
      not (self[:hide_links_for_site] and  self[:fact].site == self[:hide_links_for_site])
    end

    def scroll_to_link
      show_links ? link_to(self.pretty_url, proxy_scroll_url, :target => "_blank") : self.pretty_url
    end

    def link
      displaystring = h self[:fact].data.displaystring
      show_links ? link_to(displaystring, self[:fact].site.url, :target => "_blank") : displaystring
    end
    
    def user_opinion
      current_graph_user.opinion_on(self[:fact])
    end



  
  end
end
