class MapReduce
  class ChannelAuthority < MapReduce
    def map iterator
      iterator.each do |fact|
        fact.channel_ids.each do |ch_id|
          authority = Authority.from fact
          yield({user_id: fact.created_by_id, channel_id: ch_id }, authority)
        end
      end
    end

    def reduce bucket, values
      return values.inject(0) {|sum, value| sum += value }
    end
  end
end
