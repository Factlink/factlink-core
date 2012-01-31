class MapReduce
  def map iterator
    result_hash = {}
    internal_map iterator do |bucket, value|
      result_hash[bucket] ||= []
      result_hash[bucket] << value
    end
    result_hash
  end

  def reduce iterator
    results_hash = {}
    iterator.each_pair do |bucket, partials|
      results_hash[bucket] = (internal_reduce bucket, partials)
    end
    results_hash
  end

  def map_reduce iterator
    reduce(map(iterator))
  end

end
