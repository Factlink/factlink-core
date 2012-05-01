class MapReduce
  class TopicAuthority < MapReduce
    def all_set
      Channel.all
    end

    def map iterator
      iterator.each do |ch|
        Authority.all_from(ch).each do |authority|
          Topic.ensure_for_channel(ch)
          yield({topic: ch.slug_title, user_id: authority.user_id}, authority.to_f)
        end
      end
    end

    def reduce bucket, values
      values.inject(0) {|sum,val| sum += val}
    end

    def write_output ident, value
      topic = Topic.by_slug(ident[:topic])

      gu = GraphUser[ident[:user_id]]
      Channel.find(created_by_id: ident[:user_id], slug_title: ident[:topic]).each do |ch|
        gu.channels_by_authority.add ch, value
      end
      topic.top_users_add(gu.user, value)
      Authority.from(topic, for: gu) << value
    end
  end
end
