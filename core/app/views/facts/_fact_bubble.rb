module Facts
  class FactBubble < Mustache::Railstache
    def user_signed_in?
      self.view.user_signed_in?
    end

    def i_am_fact_owner
      (self[:fact].created_by == current_graph_user)
    end

    def editable_title_class
      (user_signed_in? and i_am_fact_owner) ? " edit " : ""
    end

    def scroll_to_link
      if show_links
        link_to(pretty_url, proxy_scroll_url, :target => "_blank")
      else
        pretty_url
      end
    end

    def displaystring
      displaystring = self[:fact].data.displaystring

      if self[:limit_characters_to_display]
        displaystring = truncate(displaystring, {length: self[:limit_characters_to_display]})
      end

      h displaystring
    end

    def link
      displaystring = h self[:fact].data.displaystring
      show_links ? link_to(displaystring, proxy_scroll_url, :target => "_blank") : displaystring
    end

    def fact_title
      self[:fact].data.title
    end

    def fact_id
      self[:fact].id
    end

    alias id fact_id

    def fact_wheel
      Facts::FactWheel.for(fact: self[:fact], view: self.view, channel: self[:channel],modal: self[:modal]).to_hash
    end

    private
      def show_links
        self[:fact].site and
          not self[:hide_links] and
          not bubble_is_on_facts_site
      end

      def bubble_is_on_facts_site
        self[:hide_links_for_site] and self[:fact].site == self[:hide_links_for_site]
      end

      def proxy_scroll_url
        FactlinkUI::Application.config.proxy_url + "/?url=" + CGI.escape(self[:fact].site.url) + "&scrollto=" + URI.escape(self[:fact].id)
      rescue
        nil
      end

      def pretty_url
        self[:fact].site.url.gsub(/http(s?):\/\//,'').split('/')[0]
      rescue
        ""
      end

  end
end
