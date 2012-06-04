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
      if show_links
        link_to(pretty_url, proxy_scroll_url, :target => "_blank")
      else
        not pretty_url.blank? ? pretty_url : nil
      end
    end

    def displaystring
      if self[:limit_characters_to_display]
        return truncate(self[:fact].data.displaystring, {length: self[:limit_characters_to_display]})
      else
        return truncate(self[:fact].data.displaystring, :omission => "", :length => 288)
      end
    end

    def full_displaystring
      self[:fact].data.displaystring
    end

    def big_displaystring?
      displaystring != full_displaystring
    end

    def fact_title
      self[:fact].data.title
    end

    def fact_wheel
      Facts::FactWheel.for(fact: self[:fact], view: self.view, channel: self[:channel],modal: self[:modal]).to_hash
    end

    def pretty_url
      self[:fact].site.url.gsub(/http(s?):\/\//,'').split('/')[0]
    rescue
      ""
    end

    def proxy_scroll_url
      FactlinkUI::Application.config.proxy_url + "/?url=" + CGI.escape(self[:fact].site.url) + "&scrollto=" + URI.escape(self[:fact].id)
    rescue
      ""
    end

    private
      def show_links
        not (self[:hide_links_for_site] and self[:fact].site == self[:hide_links_for_site]) and not self[:hide_links] and self[:fact].site
      end
	end
end
