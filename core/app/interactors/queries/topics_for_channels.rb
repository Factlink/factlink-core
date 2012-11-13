module Queries
  class TopicsForChannels
    include Pavlov::Query

    arguments :channels

    def execute
      @channels.map do |ch|
        Topic.by_slug ch.slug_title
      end
    end

    def authorized?
      true
    end
  end
end
