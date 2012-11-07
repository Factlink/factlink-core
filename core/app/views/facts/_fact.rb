module Facts
  class Fact < Mustache::Railstache
    include BaseViews::FactBase
    include BaseViews::FactBubbleBase

    def init
      self[:timestamp] ||= 0
    end

    def delete_from_channel_link
      remove_from_channel_path
    end

    def deletable_from_channel?
      user_signed_in? and self[:channel] and self[:channel].editable? and self[:channel].created_by == current_graph_user
    end

    def remove_from_channel_path
      if self[:channel] and current_user
        fast_remove_fact_from_channel_path(current_user.username, self[:channel].id, self[:fact].id)
      end
    end

    def i_am_owner
      (self[:fact].created_by == current_graph_user)
    end

    def my_authority
      auth = Authority.on(self[:fact], for: current_graph_user)
      return false if auth.to_f == 0.0

      (auth.to_s.to_f + 1.0).to_s
    end

    def ajax_loader_image
      image_tag("ajax-loader.gif")
    end

    def evidence_search_path
      evidence_search_fact_path(self[:fact].id)
    end

    def prefilled_search_value
      params[:s] ? 'value="#{params[:s]}"' : ""
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
      friendly_fact_path(self[:fact])
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
    def factlink_path
      link_to "Factlink", friendly_fact_path(self[:fact])
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

    def believers_text
      t(:fact_believe_opinion).titleize
    end
    def doubters_text
      t(:fact_doubt_opinion).titleize
    end
    def disbelievers_text
      t(:fact_disbelieve_opinion).titleize
    end
  end
end
