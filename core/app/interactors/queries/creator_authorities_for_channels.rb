module Queries
  # Given a list of channels this query returns a list of
  # authorities, which match in position
  #
  # Performance
  #
  # We make sure to retrieve all the topics needed for this
  # query at once, but don't cache the authorities. In the usecase
  # which demanded this query, it never happens that we have
  # multiple channels with the same topic, so optimization wouldn't
  # actually optimize anything
  class CreatorAuthoritiesForChannels
    include Pavlov::Query
    arguments :channels
    def execute
      @channels.map {|ch| authority_for(ch)}
    end

    def authority_for(channel)
      query :authority_on_topic_for, topic_for(channel), channel.created_by
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
  end
end
