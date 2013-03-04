module Facts
  class Fact
    def initialize options={}
      @fact = options[:fact]
      @channel = options[:channel]
      @view = options[:view]

      @timestamp = options[:timestamp] || 0
    end

    def to_hash
      json = JbuilderTemplate.new(@view)

      json.partial! partial: 'facts/fact',
                formats: [:json], handlers: [:jbuilder],
                locals: { fact: @fact, channel: @channel, timestamp: @timestamp }

      json.attributes!
    end

  end
end
