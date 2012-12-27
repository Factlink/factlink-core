class MapReduce
  class TopicAuthority < MapReduce
    def all_set
      Channel.all
    end

    def map iterator
      iterator.each do |ch|
        if ch.type == 'channel'
          Topic.ensure_for_channel(ch)
          Authority.all_from(ch).each do |authority|
            yield({topic: ch.slug_title, user_id: authority.user_id}, authority.to_f)
          end
          auth = (authority_from_added_facts(ch) + authority_from_followers(ch))
          if auth > 0
            yield({topic: ch.slug_title, user_id: ch.created_by_id}, auth)
          end
        end
      end
    end


    def authority_from_followers ch
      ch.containing_channels.count
    end

    def authority_from_added_facts ch
      [ch.sorted_internal_facts.count.to_f / 10, 5].min
    end

    def reduce bucket, values
      values.inject(0) {|sum,val| sum += val}
    end

    def write_output ident, value
      topic = Topic.by_slug(ident[:topic])

      gu = GraphUser[ident[:user_id]]
      topic.top_users_add(gu.user, value) if gu.user
      Authority.from(topic, for: gu) << value
    end
  end
end
