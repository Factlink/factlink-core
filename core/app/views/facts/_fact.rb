module Facts
  class Fact < Mustache::Railstache
    include BaseViews::FactBubbleBase

    def init
      self[:timestamp] ||= 0
    end

    def displaystring
      self[:fact].data.displaystring
    end

    def id
      self[:fact].id
    end

    def nr_of_supporting_facts
      self[:fact].supporting_facts.size
    end

    def nr_of_weakening_facts
      self[:fact].weakening_facts.size
    end

    def interacting_users
      if self[:show_interacting_users]
        Facts::InteractingUsers.for(fact: self[:fact], view: self.view, user_count: 3).to_hash
      else
        {activity: []}
      end
    end

    def signed_in?
      user_signed_in?
    end

    def containing_channel_ids
      return [] unless current_graph_user
      current_graph_user.containing_channel_ids(self[:fact])
    end

    def deletable_from_channel?
      user_signed_in? and self[:channel] and self[:channel].editable? and self[:channel].created_by == current_graph_user
    end

    def i_am_owner
      (self[:fact].created_by == current_graph_user)
    end

    def modal?
      if self[:modal] != nil
        self[:modal]
      else
        false
      end
    end

    def fact_bubble
      Facts::FactBubble.for(fact: self[:fact], view: self.view).to_hash
    end

    def url
      if self[:channel]
        channel_fact_path( self[:channel].created_by.user.username, self[:channel].id, self[:fact].id )
      else
        friendly_fact_path(self[:fact])
      end
    end

    def post_action
      if self[:channel]
        if self[:fact].created_by == self[:channel].created_by #current_user
          'Posted'
        else
          'Reposted'
        end
      end
    end

    def friendly_time
      if self[:channel]
        time_ago = [Time.at(self[:timestamp]/1000), Time.now-60].min # Compare with Time.now-60 to prevent showing 'less than a minute ago'
        time_ago_in_words(time_ago)
      end
    end

    expose_to_hash :timestamp

    # imported from extended fact:
    def created_by
      user = self[:fact].created_by.user

      json = Jbuilder.new
      json.username user.username
      json.avatar image_tag(user.avatar_url(size: 32), title: user.username, alt: user.username, width: 32)
      json.authority_for_subject authority: (Authority.on(self[:fact], for: user.graph_user).to_s.to_f + 1.0).to_s, id: self[:fact].id
      json.url user_profile_path(user)

      json.attributes!
    end

    def created_by_ago
      "#{time_ago_in_words(self[:fact].data.created_at)} ago"
    end

    def users_authority
      Authority.on(self[:fact], for: current_graph_user).to_s.to_f + 1.0
    end

    def believers_count
      self[:fact].opiniated(:believes).count
    end
    def disbelievers_count
      self[:fact].opiniated(:disbelieves).count
    end
    def doubters_count
      self[:fact].opiniated(:doubts).count
    end
  end
end
