module Facts
  class FactBubble < Mustache::Railstache
    include BaseViews::FactBubbleBase

    def link
      displaystring = h self[:fact].data.displaystring
      show_links ? link_to(displaystring, proxy_scroll_url, :target => "_blank") : displaystring
    end

    def fact_id
      self[:fact].id
    end

    def url
      friendly_fact_path(self[:fact])
    end

    alias id fact_id
  end
end
