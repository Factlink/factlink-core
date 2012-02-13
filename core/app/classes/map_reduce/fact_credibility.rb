class MapReduce
  class FactCredibility < MapReduce
    def all_set
      Channel.all
    end

    def map iterator
      iterator.each do |ch|
        ch.facts.each do |f|
          t = Topic.by_title(ch.title)
          t.save if t.new?
          Authority.all_from(t).each do |a|
            yield({fact_id: f.id, user_id: a.user_id}, a.to_f)
          end
        end
      end
    end

    def reduce bucket, authorities
      authorities.inject(0,:+) / authorities.size
    end

    def write_output bucket, value
      Authority.on(Basefact[bucket[:fact_id]], for: GraphUser[bucket[:user_id]]) << value
    end
  end
end
