module Queries
  class CreatorAuthoritiesForChannels
    include Pavlov::Query
    arguments :channels
    def execute
      @channels.map {|ch| authority_for(ch)}
    end

    def authority_for(channel)
      query :authority_on_topic_for, topic_for(channel)
    end

    def topics
      @topics ||= query :topics_for_channels, @channels
    end

    def topics_by_slug
      @topics_by_slug ||= hash_with_index(:slug_title, topics)
    end

    def topic_for(channel)
      topics_by_slug[channel.slug_title]
    end

    def authorized?

      true
    end
  end
end
