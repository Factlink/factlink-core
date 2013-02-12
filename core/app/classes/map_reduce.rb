class MapReduce

  require_relative 'map_reduce/channel_authority.rb'
  require_relative 'map_reduce/fact_authority.rb'
  require_relative 'map_reduce/fact_credibility.rb'
  require_relative 'map_reduce/fact_relation_credibility.rb'
  require_relative 'map_reduce/topic_authority.rb'

  def wrapped_map iterator
    result_hash = {}
    map iterator do |bucket, value|
      result_hash[bucket] ||= []
      result_hash[bucket] << value
    end
    result_hash
  end

  def wrapped_reduce iterator
    results_hash = {}
    iterator.each_pair do |bucket, partials|
      results_hash[bucket] = (reduce bucket, partials)
    end
    results_hash
  end

  def map_reduce iterator
    wrapped_reduce(wrapped_map(iterator)).each_pair do |key, value|
      write_output key, value
    end
  end

  def process_all
    map_reduce(all_set)
  end
end
