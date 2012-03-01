module Facts
  class ExtendedFact < Mustache::Railstache
    def factlink_path
      link_to "Factlink", friendly_fact_path(self[:fact])
    end

    def fact_wheel
      Facts::FactWheel.for(fact: self[:fact], view: self.view).to_hash
    end

    def displaystring
      self[:fact].data.displaystring
    end

    def id
      self[:fact].id
    end

    def editable_title_class
      (user_signed_in? and i_am_fact_owner) ? " edit " : ""
    end

    def user_signed_in?
      self.view.user_signed_in?
    end

    def i_am_fact_owner
      (self[:fact].created_by == current_graph_user)
    end

    def scroll_to_link
      show_links ? link_to(pretty_url, proxy_scroll_url, :target => "_blank") : pretty_url
    end

    def created_by
      self[:fact].created_by.user.username
    end

    def channels_definition
      t(:channels).titleize
    end

    def created_by_url
      user_profile_path(self[:fact].created_by.user)
    end

    def created_by_ago
      "#{time_ago_in_words(self[:fact].data.created_at)} ago"
    end

    def pretty_url
      self[:fact].site.url.gsub(/http(s?):\/\//,'').split('/')[0]
    rescue
      ""
    end

    def users_authority
      Authority.on(self[:fact], for: current_graph_user).to_s.to_f + 1.0
    end

    def nr_of_supporting_facts
      self[:fact].supporting_facts.size
    end

    def nr_of_weakening_facts
      self[:fact].weakening_facts.size
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

    def interacting_users
      Facts::InteractingUsers.for(fact: self[:fact], view: self.view, user_count: 5).to_hash
    end

    def signed_in?
      user_signed_in?
    end

    def containing_channel_ids
      return [] unless current_graph_user
      current_graph_user.containing_channel_ids(self[:fact])
    end

    def proxy_scroll_url
      FactlinkUI::Application.config.proxy_url + "/?url=" + URI.escape(self[:fact].site.url) + "&scrollto=" + URI.escape(self[:fact].id)
    rescue
      ""
    end

    private
      def show_links
        not (self[:hide_links_for_site] and  self[:fact].site == self[:hide_links_for_site]) and self[:fact].site
      end
  end
end