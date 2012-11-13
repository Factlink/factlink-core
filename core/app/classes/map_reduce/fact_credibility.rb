class MapReduce
  class FactCredibility < MapReduce
    def all_set
      Channel.all.find_all { |ch| ch.type == "channel" }
    end

    def authorities_from_topic(topic)
      @topic_authorities ||= {}
      @topic_authorities[topic.id] ||= Authority.all_from(topic)
    end

    def map iterator
      iterator.each do |ch|
        ids = ch.sorted_cached_facts.ids
        authorities_from_topic(ch.topic).each do |a|
          ids.each do |fact_id|
            yield({fact_id: fact_id, user_id: a.user_id}, a.to_f)
          end
        end
      end
    end

    def reduce bucket, authorities
      authorities.inject(0,:+) / authorities.size
    end

    def write_output bucket, value
      f = Basefact[bucket[:fact_id]]
      gu = GraphUser[bucket[:user_id]]
      if f and gu
        Authority.on(f, for: gu) << value
      end
    end
  end
end
