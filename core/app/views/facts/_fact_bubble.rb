module Facts
  class FactBubble
    def self.for(*args)
      new(*args)
    end

    def initialize options={}
      @fact = options[:fact]
      @view = options[:view]
    end

    def to_hash
      json = JbuilderTemplate.new(@view)

      json.fact_id @fact.id
      json.url @view.friendly_fact_path(@fact)
      json.id @fact.id

      base = BaseViews::FactBubbleBase.new @fact, @view
      base.add_to_json json

      json.attributes!
    end
  end
end
