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
      show_links ? link_to(pretty_url, proxy_scroll_url, :target => "_blank") : pretty_url
    end

    def displaystring
      displaystring = h self[:fact].data.displaystring
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
        not (self[:hide_links_for_site] and  self[:fact].site == self[:hide_links_for_site]) and self[:fact].site
      end

      def proxy_scroll_url
        FactlinkUI::Application.config.proxy_url + "/?url=" + URI.escape(self[:fact].site.url) + "&scrollto=" + URI.escape(self[:fact].id)
      end

      def pretty_url
        if self[:fact].site
          self[:fact].site.url.gsub(/http(s?):\/\//,'').split('/')[0]
        else
          ""
        end
      end

  end
end
