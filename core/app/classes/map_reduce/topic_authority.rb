class MapReduce
  class TopicAuthority < MapReduce
    def all_set
      Channel.all
    end

    # TODO: convert to using topic ids
    # make sure to cache topics
    def map iterator
      iterator.ids.each do |ch_id|
        channel = Channel[ch_id]
        if channel.type == 'channel'
          Topic.get_or_create_by_channel(channel)
          Authority.all_from(channel).each do |authority|
            yield({
              topic: channel.slug_title,
              user_id: authority.user_id
            }, authority.to_f)
          end
          auth = (authority_from_added_facts(channel) +
                  authority_from_followers(channel))
          if auth > 0
            yield({
              topic: channel.slug_title,
              user_id: channel.created_by_id
            }, auth)
          end
        end
      end
    end

    def authority_from_followers channel
      channel.containing_channels.count
    end

    def authority_from_added_facts channel
      [channel.sorted_internal_facts.count.to_f / 10, 5].min
    end

    def reduce bucket, values
      values.inject(0, :+)
    end

    def write_output ident, value
      topic = Topic.by_slug(ident[:topic])
      graph_user = DeadGraphUser.new(ident[:user_id])
      Authority.from(topic, for: graph_user) << value

      Resque.enqueue(Commands::Topics::UpdateUserAuthority, graph_user_id: graph_user.id, topic_slug: topic.slug_title, authority: value)
    end
  end
end
