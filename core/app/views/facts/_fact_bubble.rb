module Facts
  class FactBubble
    def self.for(*args)
      new(*args)
    end

    def initialize options={}
      @fact = options[:fact]
      @view = options[:view]
    end

    def base
      BaseViews::FactBubbleBase.new @fact, @view
    end

    def to_hash
      displaystring = @view.send(:h, @fact.data.displaystring)
      link = @view.link_to(displaystring, base.proxy_scroll_url, :target => "_blank")

      json = JbuilderTemplate.new(@view)

      json.link link
      json.fact_id @fact.id
      json.url @view.friendly_fact_path(@fact)
      json.id @fact.id

      base.add_to_json json

      json.attributes!
    end
  end
end
