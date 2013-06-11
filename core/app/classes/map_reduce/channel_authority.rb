class MapReduce
  class ChannelAuthority < MapReduce
    def all_set
      Fact.all
    end

    def map iterator
      iterator.each do |fact|
        fact.channel_ids.each do |ch_id|
          authority = Authority.from(fact).to_f
          if authority > 0
            yield({user_id: fact.created_by_id, channel_id: ch_id }, authority)
          end
        end
      end
    end

    def reduce bucket, values
      values.inject(0, :+)
    end

    def write_output ident, value
      # TODO use dead channel and dead graph user
      ch = Channel[ident[:channel_id]]
      gu = GraphUser[ident[:user_id]]
      if ch and gu
        Authority.from(ch, for: gu) << value
      end
    end

  end
end
