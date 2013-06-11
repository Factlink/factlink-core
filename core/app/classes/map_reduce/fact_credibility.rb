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
        fact_ids = ch.sorted_cached_facts.ids
        authorities_from_topic(ch.topic).each do |a|
          fact_ids.each do |fact_id|
            yield({fact_id: fact_id, user_id: a.user_id}, a.to_f)
          end
        end
      end
    end

    def reduce bucket, authorities
      authorities.inject(0,:+) / authorities.size
    end

    def write_output bucket, value
      f = DeadFact.new(bucket[:fact_id])
      if f and gu
      gu = GraphUser[bucket[:user_id]] # TODO use dead graph user
        Authority.on(f, for: gu) << value
      end
    end
  end
end
