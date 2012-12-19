module Facts
  class FactBubble
    include BaseViews::FactBubbleBase

    def self.for(*args)
      new(*args)
    end

    def initialize options={}
      @fact = options[:fact]
      @view = options[:view]
    end

    def link
      displaystring = @view.send(:h, @fact.data.displaystring)

      @view.link_to(displaystring, proxy_scroll_url, :target => "_blank")
    end

    def fact_id
      @fact.id
    end

    def url
      @view.friendly_fact_path(@fact)
    end

    def to_hash
      json = JbuilderTemplate.new(@view)

      json.link link
      json.fact_id fact_id
      json.url url
      json.id fact_id

      json.user_signed_in? user_signed_in?
      json.i_am_fact_owner i_am_fact_owner
      json.can_edit? can_edit?
      json.scroll_to_link scroll_to_link
      json.displaystring displaystring
      json.fact_title fact_title
      json.fact_wheel do |j|
        fact_wheel j
      end
      json.believe_percentage believe_percentage
      json.disbelieve_percentage disbelieve_percentage
      json.doubt_percentage doubt_percentage
      json.fact_url fact_url
      json.proxy_scroll_url proxy_scroll_url

      json.attributes!
    end
  end
end
