module Facts
  class FactBubble
    def initialize options={}
      @fact = options[:fact]
      @view = options[:view]
    end

    def to_hash
      json = JbuilderTemplate.new(@view)

      json.url @view.friendly_fact_path(@fact)
      json.id @fact.id
      json.displaystring @fact.data.displaystring

      base = BaseViews::FactBubbleBase.new @fact, @view
      base.add_to_json json

      json.attributes!
    end
  end
end
