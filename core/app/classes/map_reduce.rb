class MapReduce
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
    wrapped_reduce(wrapped_map(iterator))
  end

end
