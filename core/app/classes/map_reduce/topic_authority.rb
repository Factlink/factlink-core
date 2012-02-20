class MapReduce
  class TopicAuthority < MapReduce
    def all_set
      Channel.all
    end

    def map iterator
      iterator.each do |ch|
        Authority.all_from(ch).each do |authority|
          yield({topic: ch.title, user_id: authority.user_id}, authority.to_f)
        end
      end
    end

    def reduce bucket, values
      values.inject(0) {|sum,val| sum += val}
    end

    def write_output ident, value
      topic = Topic.by_title(ident[:topic])
      topic.save if topic.new?
      gu = GraphUser[ident[:user_id]]
      Authority.from(topic, for: gu) << value
    end
  end
end
