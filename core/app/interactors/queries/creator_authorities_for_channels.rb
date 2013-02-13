require_relative '../../classes/util'

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
  #
  # We cache the graph_users after they're retrieved, since
  # the most common use case is to get the channels of one
  # user, which means that we will now typically get
  # O(constant) graph_user retrievals (2 redis commands)
  # instead of O(N).
  # We also set this property on the channel. This is a nasty hack,
  # but otherwise we would still get this O(N) retrieval in
  # interactors/queries which get run after this one on the same
  # channel
  class CreatorAuthoritiesForChannels
    include Pavlov::Query
    arguments :channels
    def execute
      @channels.map {|ch| authority_for(ch)}
    end

    def authority_for(channel)
      if channel.type == 'channel'
        topic = topic_for(channel)
        graph_user = graph_user_for(channel)
        query :authority_on_topic_for, topic, graph_user
      else
        # channel is a userstream or a created facts channel,
        # so there is no topic, therefor we define authority as 0
        0
      end
    end

    def graph_user_for channel
      gu = graph_user channel.created_by_id
      channel.send :write_local, :created_by, gu
      gu
    end

    def graph_user id
      @graph_users     ||= {}
      @graph_users[id] ||= GraphUser[id]
    end

    def topics
      @topics ||= query :topics_for_channels, @channels
    end

    def topics_by_slug
      @topics_by_slug ||= Utils.hash_with_index(:slug_title, topics)
    end

    def topic_for(channel)
      topics_by_slug[channel.slug_title]
    end
  end
end
