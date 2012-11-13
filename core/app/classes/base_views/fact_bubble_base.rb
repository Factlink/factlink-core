module BaseViews
  module FactBubbleBase
    def user_signed_in?
      self.view.user_signed_in?
    end

    def i_am_fact_owner
      (self[:fact].created_by == current_graph_user)
    end

    def can_edit?
      user_signed_in? and i_am_fact_owner
    end

    def scroll_to_link
      if show_links and fact_title
        link_to(fact_title, proxy_scroll_url, :target => "_blank")
      elsif not fact_title.blank?
        fact_title
      else
        nil
      end
    end

    def displaystring
      self[:fact].data.displaystring
    end

    def fact_title
      self[:fact].data.title
    end

    def fact_wheel
      Facts::FactWheel.for(fact: self[:fact], view: self.view, channel: self[:channel],modal: self[:modal]).to_hash
    end

    def proxy_scroll_url
      FactlinkUI::Application.config.proxy_url + "/?url=" + CGI.escape(self[:fact].site.url) + "&scrollto=" + URI.escape(self[:fact].id)
    rescue
      ""
    end

    private
      def show_links
        hide_links_on_this_site = self[:hide_links_for_site] # (self[:hide_links_for_site] and self[:fact].site == self[:hide_links_for_site])

        self[:fact].site and not ( self[:hide_links] or hide_links_on_this_site)
      end
  end
end
