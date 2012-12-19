module Facts
  class FactBubble
    def self.for(*args)
      new(*args)
    end

    def initialize options={}
      @fact = options[:fact]
      @view = options[:view]
    end

    def link
      displaystring = @view.send(:h, @fact.data.displaystring)

      @view.link_to(displaystring, base.proxy_scroll_url, :target => "_blank")
    end

    def fact_id
      @fact.id
    end

    def url
      @view.friendly_fact_path(@fact)
    end

    def base
      BaseViews::FactBubbleBase.new @fact, @view
    end

    def to_hash
      json = JbuilderTemplate.new(@view)

      json.link link
      json.fact_id fact_id
      json.url url
      json.id fact_id

      base.add_to_json json

      json.attributes!
    end
  end
end
