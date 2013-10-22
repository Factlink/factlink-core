class MapReduce
  class FactCredibility < MapReduce
    def all_set
      # TODO don't retrieve all and filter clientside, do something smarter
      Channel.all
    end

    def authorities_from_topic(topic)
      @topic_authorities ||= {}
      @topic_authorities[topic.id] ||= Authority.all_from(topic)
    end

    def map iterator
      iterator.each do |channel|
        fact_ids = channel.sorted_cached_facts.ids
        authorities_from_topic(channel.topic).each do |authority|
          fact_ids.each do |fact_id|
            yield({
              fact_id: fact_id,
              graph_user_id: authority.user_id
            }, authority.to_f)
          end
        end
      end
    end

    def reduce bucket, authorities
      authorities.inject(0,:+) / authorities.size
    end

    def write_output bucket, value
      fact = DeadFact.new(bucket[:fact_id])
      graph_user = DeadGraphUser.new bucket[:graph_user_id]

      Authority.on(fact, for: graph_user) << value
    end
  end
end
