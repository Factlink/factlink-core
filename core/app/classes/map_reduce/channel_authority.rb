class MapReduce
  class ChannelAuthority < MapReduce
    def all_set
      Fact.all
    end

    def map iterator
      iterator.ids.each do |id|
        fact = Fact[id]
        fact.channel_ids.each do |channel_id|
          authority = Authority.from(fact).to_f
          if authority > 0
            yield({
              graph_user_id: fact.created_by_id,
              channel_id: channel_id
            }, authority)
          end
        end
      end
    end

    def reduce bucket, values
      values.inject(0, :+)
    end

    def write_output ident, value
      # TODO use dead channel
      channel = DeadChannel.new ident[:channel_id]
      graph_user = DeadGraphUser.new ident[:graph_user_id]

      Authority.from(channel, for: graph_user) << value
    end
  end
end
